cask "lightproxy" do
  version "1.1.41"
  sha256 "e71f606717712eabb06e1cf0c643302f8d52d339d227367a16ca519883d4bd00"

  url "https:github.comalibabalightproxyreleasesdownloadv#{version}LightProxy-#{version}.dmg",
      verified: "github.comalibabalightproxy"
  name "LightProxy"
  desc "Proxy & Debug tools based on whistle with Chrome Devtools UI"
  homepage "https:alibaba.github.iolightproxy"

  app "LightProxy.app"

  uninstall_postflight do
    stdout, * = system_command "usrbinsecurity",
                               args: ["find-certificate", "-a", "-c", "LigthProxy", "-Z"],
                               sudo: true
    hashes = stdout.lines.grep(^SHA-256 hash:) { |l| l.split(":").second.strip }
    hashes.each do |h|
      system_command "usrbinsecurity",
                     args: ["delete-certificate", "-Z", h],
                     sudo: true
    end
  end
end