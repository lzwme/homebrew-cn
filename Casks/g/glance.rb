cask "glance" do
  version "1.2.0"
  sha256 "8584901c292a2a7ce084ee25b0b3e020d143e193ab198b69831b398cdc164c06"

  url "https:github.comsamuelmeuliglancereleasesdownloadv#{version}Glance.dmg"
  name "Glance"
  desc "Utility to provide quick look previews for files that aren't natively supported"
  homepage "https:github.comsamuelmeuliglance"

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :catalina"

  app "Glance.app"

  zap trash: [
    "~LibraryApplication Scriptscom.samuelmeuli.Glance",
    "~LibraryApplication Scriptscom.samuelmeuli.Glance.QLPlugin",
    "~LibraryContainerscom.samuelmeuli.Glance",
    "~LibraryContainerscom.samuelmeuli.Glance.QLPlugin",
    "~LibraryGroup Containersgroup.com.samuelmeuli.glance",
  ]

  caveats do
    <<~EOS
      You must start #{appdir}Glance.app once manually to setup the QuickLook plugin.
    EOS
  end
end