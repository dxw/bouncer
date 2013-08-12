module Bouncer
  module Outcome
    class Status < Base
      def serve
        case context.mapping.try(:http_status)
        when '301'
          guarded_redirect(context.mapping.new_url)
        when '410'
          [410, { 'Content-Type' => 'text/html' }, [renderer.render(context, 410)]]
        else
          if request.path == '/410'
            [410, { 'Content-Type' => 'text/html' }, [renderer.render(context, 410)]]
          else
            Bouncer::Rules.try(request, renderer) or
              [404, { 'Content-Type' => 'text/html' }, [renderer.render(context, 404)]]
          end
        end
      end
    end
  end
end
