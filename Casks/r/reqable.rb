cask "reqable" do
  arch arm: "arm64", intel: "x86_64"

  version "2.22.1"
  sha256 arm:   "9690b5758ae9b617f29eb9b90d37faca002cb6750fb802a96d0273f0441335d6",
         intel: "5ac127d3e31d7220e5b71ac3f10deba6580db7e268662245b980bb1647701b57"

  url "https:github.comreqablereqable-appreleasesdownload#{version}reqable-app-macos-#{arch}.dmg",
      verified: "github.comreqablereqable-app"
  name "Reqable"
  desc "Advanced API Debugging Proxy"
  homepage "https:reqable.com"

  auto_updates true

  app "Reqable.app"

  uninstall_postflight do
    stdout, * = system_command "usrbinsecurity",
                               args: ["find-certificate", "-a", "-c", "Reqable Proxy", "-Z"],
                               sudo: true
    hashes = stdout.lines.grep(^SHA-256 hash:) { |l| l.split(":").second.strip }
    hashes.each do |h|
      system_command "usrbinsecurity",
                     args: ["delete-certificate", "-Z", h],
                     sudo: true
    end
  end

  zap trash: [
    "~LibraryCachesReqable",
    "~LibraryPreferencescom.reqable.macosx.plist",
  ]
end