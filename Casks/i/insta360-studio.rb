cask "insta360-studio" do
  version "5.0.0,RC_build171,6500b773e9cbaba798d5cb936351537c,20240326_025731_signed_1711393131783"
  sha256 "8ebf85712157d2955c3e7bb0a68440dd1077866ae574ad2e2e398be2bcfa6be3"

  url "https://file.insta360.com/static/#{version.csv.third}/Insta360Studio_#{version.csv.first}(#{version.csv.second})_#{version.csv.fourth}.pkg"
  name "Insta360 Studio"
  desc "Video and photo editor"
  homepage "https://www.insta360.com/"

  livecheck do
    url "https://openapi.insta360.com/app/appDownload/getGroupApp?group=insta360-go2&X-Language=en-us"
    regex(%r{
      /(\h+)/
      Insta360Studio
      (?:[._-]|%20)(?:\d+(?:\.\d+)+)
      (?:[._-]?\(([^)]+?)\))?
      [._-](\d+(?:[._-](?:\d+|signed))*)
      \.pkg
    }ix)
    strategy :json do |json, regex|
      # Find the Insta360 Studio app
      app = json.dig("data", "apps")&.find { |item| item["id"] == 38 }
      next if app.blank?

      # Find the newest macOS version
      newest_release = app["items"]&.select { |item| item["platform"] == "mac" }
                                   &.max_by { |item| Version.new(item["version"]) }
      next if newest_release.blank?

      # Find the channel item (there's likely only one object in the array)
      channel = newest_release["channels"]&.find { |item| item["channel"] == "official" }
      next if channel.blank?

      # Collect the version parts
      version = newest_release["version"]
      match = channel["download_url"]&.match(regex)
      next if version.blank? || match.blank?

      "#{version},#{match[2]},#{match[1]},#{match[3]}#{",#{match[4]}" if match[4].present?}"
    end
  end

  pkg "Insta360Studio_#{version.csv.first}(#{version.csv.second})_#{version.csv.fourth}.pkg"

  uninstall quit:    "com.insta360.studio",
            pkgutil: [
              "com.insta360.insta360Studio",
              "com.insta360.PremierePlugin",
              "com.insta360.ThumbnailPlugin",
            ],
            delete:  "/Applications/Insta360 Studio #{version.csv.third.split("_")[0]}.app"

  zap trash: [
    "~/Library/Application Support/Insta360",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/com.insta360.studio",
    "~/Library/Caches/Insta360",
    "~/Library/Saved Application State/com.insta360.studio.savedState",
  ]
end