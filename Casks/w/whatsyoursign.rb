cask "whatsyoursign" do
  version "3.0.1"
  sha256 "691e5873509d30f0a6c4be01eca14cf9d551fcb4510b6739835929a3f33e779e"

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