# frozen_string_literal: true

require "uri"
require "download_strategy"
require_relative "../vendor/bundle/ruby/2.6.0/gems/b2-client-1.0.7/lib/b2"

# The B2DownloadStrategy enables downlaods from the backblaze API. In order for
# it to be usable the environment variables HOMEBREW_B2_KEY_ID and
# HOMEBREW_B2_APPLICATION_KEY must be set to appropriate values.
class B2DownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    parsed = URI(url)
    raise "Invalid scheme for B2: #{parsed.scheme}" if parsed.scheme != "b2"
    if parsed.host != "backblazeb2.com"
      # Maybe this is too restrictive?
      raise "Currently only backblazeb2.com is supported as B2 host: #{parsed.host}"
    end

    _, @bucket, @file = parsed.path.split("/", 3)
    raise "URL must contain a bucket and a file path" unless [@bucket, @file].all?
  end

  private

  def _fetch(*)
    key_id = ENV.fetch("HOMEBREW_B2_KEY_ID", nil)
    app_key = ENV.fetch("HOMEBREW_B2_APPLICATION_KEY", nil)
    onoe "Missing HOMEBREW_B2_KEY_ID" if key_id.blank?
    onoe "Missing HOMEBREW_B2_APPLICATION_KEY" if app_key.blank?
    raise "Missing credentials for #{url}" unless [app_key, key_id].all?

    b2 = B2.new(key_id:, secret: app_key)
    download_url = b2.get_download_url(@bucket, @file)
    curl_download(download_url, to: temporary_path)
  end
end

# We patch the DownloadStrategyDetector to recognize the b2:// URL scheme.
# Additionally we support the :b2 symbol to specify the use of the
# `B2DownloadStrategy`.
class DownloadStrategyDetector
  original_detect_from_url = singleton_class.instance_method(:detect_from_url)
  original_detect_from_symbol = singleton_class.instance_method(:detect_from_symbol)

  singleton_class.define_method(:detect_from_url) do |url|
    return B2DownloadStrategy if url.start_with? "b2://"

    original_detect_from_url.bind_call(self, url)
  end

  singleton_class.define_method(:detect_from_symbol) do |symbol|
    return B2DownloadStrategy if symbol == :b2

    original_detect_from_symbol.bind_call(self, symbol)
  end
end