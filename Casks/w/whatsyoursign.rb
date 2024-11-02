cask "whatsyoursign" do
  version "2.2.3"
  sha256 "7263fdf7b33949a3eb1756e4a0c22057dd59792e8ba40e35b6c5058a991757de"

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