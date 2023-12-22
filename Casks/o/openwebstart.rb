cask "openwebstart" do
  arch arm: "aarch64", intel: "x64"

  version "1.9.1"
  sha256 arm:   "bcbf70a3361e88646e43d5be5d9b9917e84a44fc9dde616de56c57bd663ab23d",
         intel: "cec264313bdca051e4d2890d6e8c95147d7eb9e739142efb3e5b78b6dbdf4719"

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