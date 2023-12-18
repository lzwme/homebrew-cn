cask "betwixt" do
  version "1.6.1"
  sha256 "a97f893e8bc7611dfde66ae75775a829c4d25959b946276aacf32cc8485c4054"

  url "https:github.comkdzwinelbetwixtreleasesdownload#{version}Betwixt-darwin-x64.zip"
  name "Betwixt"
  desc "Web Debugging Proxy based on Chrome DevTools Network panel"
  homepage "https:github.comkdzwinelbetwixt"

  app "Betwixt-darwin-x64Betwixt.app"

  uninstall_postflight do
    cert = Pathname("~LibraryApplication Supportbetwixtsslcertsca.pem").expand_path
    next unless cert.exist?

    stdout, * = system_command "usrbinopenssl",
                               args: [
                                 "x509",
                                 "-fingerprint", "-sha256",
                                 "-noout",
                                 "-in", cert
                               ]
    hash = stdout.lines.first.split("=").second.delete(":").strip
    stdout, * = system_command "usrbinsecurity",
                               args: ["find-certificate", "-a", "-c", "NodeMITMProxyCA", "-Z"],
                               sudo: true
    hashes = stdout.lines.grep(^SHA-256 hash:) { |l| l.split(":").second.strip }
    if hashes.include?(hash)
      system_command "usrbinsecurity",
                     args: ["delete-certificate", "-Z", hash],
                     sudo: true
    end
  end

  zap trash: [
    "~LibraryApplication Supportbetwixt",
    "~LibraryCachesbetwixt",
    "~LibraryPreferencescom.electron.betwixt.plist",
    "~LibrarySaved Application Statecom.electron.betwixt.savedState",
  ]
end