cask "v2rayx" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  version "1.5.1"
  sha256 "007ec1de5c8f768eb7be42df1980a4998fbf953d29d6c80019bd826272855239"

  url "https:github.comCenmrevV2RayXreleasesdownloadv#{version}V2RayX.app.zip"
  name "V2RayX"
  desc "GUI for v2ray-core"
  homepage "https:github.comCenmrevV2RayX"

  app "V2RayX.app"

  uninstall_preflight do
    set_ownership "LibraryApplication SupportV2RayX"
  end

  uninstall delete:    "LibraryApplication SupportV2RayX",
            launchctl: "v2rayproject.v2rayx.v2ray-core",
            script:    {
              executable: "#{appdir}V2RayX.appContentsResourcesv2rayx_sysconf",
              args:       ["off"],
              sudo:       true,
            },
            signal:    ["TERM", "cenmrev.V2RayX"]

  zap trash: [
    "~LibraryApplication SupportV2RayX",
    "~LibraryPreferencescenmrev.V2RayX.plist",
  ]
end