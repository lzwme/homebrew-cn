cask "whatsyoursign" do
  version "3.0.0"
  sha256 "3f434d3b0882f36936d928f7db3a398acb00324cf6da9af87bbd242ed8ac7f08"

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