cask "openwebstart" do
  arch arm: "aarch64", intel: "x64"

  version "1.12.0"
  sha256 arm:   "8fc8c981edea16c4ee22bd295fa7d623bd62c2ccb5474356b6869fcd1c0440d1",
         intel: "465c7c6c563c16b12eaa1281147b161101b9c823f91d0eb210eedbabd4c99c15"

  url "https:github.comkarakunOpenWebStartreleasesdownloadv#{version}OpenWebStart_macos-#{arch}_#{version.dots_to_underscores}.dmg",
      verified: "github.comkarakunOpenWebStart"
  name "OpenWebStart"
  desc "Tool to run Java Web Start-based applications after the release of Java 11"
  homepage "https:openwebstart.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  installer script: {
    executable:   "#{staged_path}OpenWebStart Installer.appContentsMacOSJavaApplicationStub",
    args:         ["-q"],
    sudo:         true,
    print_stderr: false,
  }

  uninstall_preflight do
    set_ownership "ApplicationsOpenWebStart"
  end

  uninstall \
    script: {
      executable:   "ApplicationsOpenWebStartOpenWebStart Uninstaller.appContentsMacOSJavaApplicationStub",
      args:         ["-q"],
      sudo:         true,
      print_stderr: false,
    },
    delete: "ApplicationsOpenWebStart"

  zap trash: [
    "~.cacheicedtea-web",
    "~.configicedtea-web",
  ]
end