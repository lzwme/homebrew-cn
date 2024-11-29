cask "openwebstart" do
  arch arm: "aarch64", intel: "x64"

  version "1.11.0"
  sha256 arm:   "02fce34aa785baefdea3eb91553d89a516522f30872ee88fd8a7fb1928293c42",
         intel: "dcd7b9399dfd23a446ae78f5c522643b00ea354ed893f3f93de7499f2b16a496"

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