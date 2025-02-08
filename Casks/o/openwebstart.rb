cask "openwebstart" do
  arch arm: "aarch64", intel: "x64"

  version "1.11.1"
  sha256 arm:   "4feca83691a6fc480067c8b0b5d58b3d6aa66a6a19436a232672cf6655fd5c36",
         intel: "38beeb59d1c9033952852015ad4d429a1bcefe3ca36879fbf75f80a624cf0faf"

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