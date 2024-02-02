cask "whatsyoursign" do
  version "2.2.2"
  sha256 "0359af12087997ce205d86c5ffe752084502c5896b474d4ae556da8e7147468e"

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