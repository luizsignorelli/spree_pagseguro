require 'spree_core'
require 'spree_paseguro_hooks'

module SpreePagseguro
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      #workaround for https://github.com/Shopify/active_merchant/issuesearch?state=open&q=paypal#issue/43
      require 'active_merchant'
      ActiveMerchant::Billing::PaypalExpressGateway

      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      BillingIntegration::PaypalExpress.register
      BillingIntegration::PaypalExpressUk.register
    end

    config.to_prepare &method(:activate).to_proc
  end
end
