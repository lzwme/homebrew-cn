cask "munki" do
  version "6.3.3.4593"
  sha256 "0ce71c766a729349862286ef46bc0c5b3f49ffa0abe0047c0950cb4850eec40e"

  url "https://ghproxy.com/https://github.com/munki/munki/releases/download/v#{version.major_minor_patch}/munkitools-#{version}.pkg",
      verified: "github.com/munki/munki/"
  name "Munki"
  desc "Software installation manager"
  homepage "https://www.munki.org/munki/"

  livecheck do
    url "https://github.com/munki/munki/releases/latest"
    regex(%r{href=.*?/munkitools[._-]v?(\d+(?:\.\d+)+)\.pkg}i)
    strategy :header_match do |headers, regex|
      next if headers["location"].blank?

      # Identify the latest tag from the response's `location` header
      latest_tag = File.basename(headers["location"])
      next if latest_tag.blank?

      # Fetch the assets list HTML for the latest tag and match within it
      assets_page = Homebrew::Livecheck::Strategy.page_content(
        @url.sub(%r{/releases/?.+}, "/releases/expanded_assets/#{latest_tag}"),
      )
      assets_page[:content]&.scan(regex)&.map { |match| match[0] }
    end
  end

  pkg "munkitools-#{version}.pkg"

  uninstall pkgutil:   "com.googlecode.munki.*",
            launchctl: [
              "com.googlecode.munki.app_usage_monitor",
              "com.googlecode.munki.appusaged",
              "com.googlecode.munki.logouthelper",
              "com.googlecode.munki.ManagedSoftwareCenter",
              "com.googlecode.munki.managedsoftwareupdate-check",
              "com.googlecode.munki.managedsoftwareupdate-install",
              "com.googlecode.munki.managedsoftwareupdate-manualcheck",
              "com.googlecode.munki.munki-notifier",
            ],
            delete:    "/usr/local/munki"

  zap trash: [
    "/Library/LaunchDaemons/com.googlecode.munki.appusaged.plist",
    "/Library/LaunchDaemons/com.googlecode.munki.authrestartd.plist",
    "/Library/LaunchDaemons/com.googlecode.munki.logouthelper.plist",
    "/Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-check.plist",
    "/Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-install.plist",
    "/Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-manualcheck.plist",
  ]
end