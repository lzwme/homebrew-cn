# frozen_string_literal: true

require_relative "b2_download_strategy"

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