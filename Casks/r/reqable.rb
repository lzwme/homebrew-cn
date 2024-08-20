cask "reqable" do
  arch arm: "arm64", intel: "x86_64"

  version "2.22.0"
  sha256 arm:   "853bfc8c28ae54b756413d6620a836a657c9e27c9298c95c3a4e19edcec4e04f",
         intel: "44c4f2f6d819490218f18c48ce8dec22da567a00d51dd636461d5fb183ffb4ee"

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