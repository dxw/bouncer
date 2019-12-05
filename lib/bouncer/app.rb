module Bouncer
  class App
    def initialize()
      @renderer = StatusRenderer.new
    end

    def call(env)
      context = RequestContext.new(CanonicalizedRequest.new(env))

      outcome = case
                when context.host.nil? && context.request.path == '/healthcheck'
                  Outcome::Healthcheck
                when context.host.nil?
                  Outcome::UnrecognisedHost
                when ['/404', '/410'].include?(context.request.path)
                  Outcome::TestThe4xxPages
                when context.host.hostname == 'www.direct.gov.uk' && context.request.path == '/__canary__'
                  Outcome::Canary
                when context.request.path == '/sitemap.xml'
                  Outcome::Sitemap
                when context.request.path == '/robots.txt'
                  Outcome::Robots
                when context.site.global_type
                  Outcome::GlobalType
                when context.request.path == '' # after c14n, '' is equivalent to '/'
                  Outcome::Homepage
                else
                  Outcome::Status
                end

      outcome.new(context, @renderer).serve.tap { |result| log_hit(result,context) }

    end

    def log_hit(rack_array, context)
      return if context.nil?
      return if context.mapping.nil?
      return if context.host.nil?

      RequestLogWorker.perform_async({
        hostname: context.host.hostname,
        path: context.mapping.path,
        http_status: status,
        hit_on: Date.today,
      }.to_json)
    rescue Exception => e
      # Never, ever fail.
      # The user must get the right page, even if we lose data.
    end
  end
end
