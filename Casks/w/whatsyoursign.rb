cask "whatsyoursign" do
  version "2.2.1"
  sha256 "795407b7a8fbc2dc7c2b4b83310a097c9bb6ff8777755294cfa229c0efc87b4b"

  url "https:github.comobjective-seeWhatsYourSignreleasesdownloadv#{version}WhatsYourSign_#{version}.zip",
      verified: "github.comobjective-see"
  name "What's Your Sign?"
  desc "Shows a files cryptographic signing information"
  homepage "https:objective-see.comproductswhatsyoursign.html"

  installer manual: "WhatsYourSign Installer.app"

  uninstall script: {
              executable:   "usrbinpluginkit",
              args:         [
                "-r",
                "ApplicationsWhatsYourSign.appContentsPlugInsWhatsYourSign.appex",
              ],
              must_succeed: false,
            },
            delete: [
              "ApplicationsWhatsYourSign.app",
              "~LibraryApplication Scriptscom.objective-see.WhatsYourSignExt.FinderSync",
              "~LibraryContainerscom.objective-see.WhatsYourSignExt.FinderSync",
            ]

  zap trash: "~LibrarySaved Application Statecom.objective-see.WhatsYourSign.savedState"
end