require "facturaDotCom/version"

module FacturaDotCom
 class Factura
    API_URL = "https://factura.com/api/v1"

    def initialize(api_key, api_secret)
      @api_key = api_key
      @api_secret = api_secret
    end

    def find_client(data)
      find_url = "#{API_URL}/clients/#{data}"
      res = create_get_request(find_url)
      Rails.logger.debug("\e[32m#{res}\e[0m")
      res = JSON.parse(res.body)
      if res['status'] == "error"
        result = {
          status: res['status'],
          res: res
        }
      else
        result = {
          status: res['status'],
          guid: res['Data']['UID']
        }
      end
    end

    def generate_invoice(data)
      create_url = "#{API_URL}/invoice/create"
      res = create_post_request(create_url, data.to_json)
      Rails.logger.debug "\e[32m#{res}\e[0m"
      res = JSON.parse(res.body)
      if res['status'] == "error"
        result = {
          status: res['status'],
          res: res
        }
      else
        result = {
          status: res['status'],
          guid: res['invoice_uid']
        }
      end
    end

    def create_client(data)
      create_url = "#{API_URL}/clients/create"
      res = create_post_request(create_url, data)
      Rails.logger.debug("\e[32m#{res}\e[0m")
      res = JSON.parse(res.body)
      if res['status'] == "error"
        result = {
          status: res['status'],
          res: res
        }
      else
        result = {
          status: res['status'],
          guid: res['Data']['UID']
        }
      end
    end

    def update_client(client_guid, data)
      update_url = "#{API_URL}/clients/#{client_guid}/update"
      res = create_post_request(update_url, data)
      Rails.logger.debug("\e[32m#{res}\e[0m")
      res = JSON.parse(res.body)
      if res['status'] == "error"
        result = {
          status: res['status'],
          res: res
        }
      else
        result = {
          status: res['status'],
          guid: res['Data']['UID']
        }
      end
    end

    protected
      def create_get_request(url)
        uri = URI.parse(url)
        request = Net::HTTP::Get.new(uri)
        request['Content-Type'] = 'application/json'
        request['F-API-KEY'] = @api_key
        request['F-SECRET-KEY'] = @api_secret
        http = Net::HTTP.start(uri.host, uri.port, use_ssl: true)
        response = http.request(request)
      end

      def create_post_request(url, data)
        uri = URI.parse(url)
        request = Net::HTTP::Post.new(uri)
        request['Content-Type'] = 'application/json'
        request['F-API-KEY'] = @api_key
        request['F-SECRET-KEY'] = @api_secret
        request.body = data
        http = Net::HTTP.start(uri.host, uri.port, use_ssl: true)
        response = http.request(request)
      end
  end
end
