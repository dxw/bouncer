require 'erubis'
require 'nokogiri'
require 'ostruct'
require 'rack/request'
require 'uri'
require 'sidekiq'
require 'status_renderer'
require 'host'
require 'requests'
require 'request_log_worker'
require 'whitelisted_host'
require 'optic14n'

require 'bouncer/cacher'
require 'bouncer/canonicalized_request'
require 'bouncer/request_context'
require 'bouncer/fallback_rules'
require 'bouncer/preemptive_rules'

require "bouncer/outcome/base"
require "bouncer/outcome/canary"
require "bouncer/outcome/global_type"
require "bouncer/outcome/healthcheck"
require "bouncer/outcome/unrecognised_host"
require "bouncer/outcome/robots"
require "bouncer/outcome/sitemap"
require "bouncer/outcome/status"
require "bouncer/outcome/test_the_4xx_pages"
require "bouncer/outcome/homepage"

require "bouncer/app"
