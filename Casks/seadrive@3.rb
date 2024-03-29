cask "seadrive@3" do
  version "3.0.8"
  sha256 "c00edeced8f4a92f9582e0108d6ec4c220bc1d5ed782e931feca1ba2d42e752c"

  url "https://s3.eu-central-1.amazonaws.com/download.seadrive.org/seadrive-#{version}.pkg",
      verified: "s3.eu-central-1.amazonaws.com/download.seadrive.org/"
  name "Seadrive"
  desc "Drive Client for Seafile"
  homepage "https://www.seafile.com/"

  livecheck do
    url "https://s3.eu-central-1.amazonaws.com/download.seadrive.org"
    regex(/seadrive-(\d+\.\d+\.\d+)\.pkg/i)
    strategy :xml do |xml, regex|
      xml.root.get_elements(
        "/ListBucketResult/Contents" \
        "[starts-with(Key, 'seadrive') and contains(Key, '.pkg')]/Key",
      ).map do |item|
        item.text[regex, 1]
      end
    end
  end

  depends_on macos: ">= :monterey"

  pkg "seadrive-#{version}.pkg"

  uninstall quit:       "com.seafile.seadrive",
            login_item: "SeaDrive",
            pkgutil:    "com.seafile.SeaDrive"

  zap trash: [
    "~/Library/Application Scripts/55LCTZ5354.com.seafile.seadrive",
    "~/Library/Application Scripts/com.seafile.seadrive.fprovider",
    "~/Library/CloudStorage/SeaDrive-*",
    "~/Library/Containers/com.seafile.seadrive.fprovider",
    "~/Library/Group Containers/55LCTZ5354.com.seafile.seadrive",
    "~/Library/Logs/DiagnosticReports/seadrive-gui-*",
    "~/Library/Preferences/com.seafile.Seafile Drive Client.plist",
  ]
end