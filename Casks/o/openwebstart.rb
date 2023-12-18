cask "openwebstart" do
  arch arm: "aarch64", intel: "x64"

  version "1.9.0"
  sha256 arm:   "a3792e84a804c18fb28554210dbee875fad00a653198c2664b1756ffaa86590b",
         intel: "a01b80f0db3456109b1d9371ecb3cae28ad52afea1bd44e274ee8b06f992f0de"

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