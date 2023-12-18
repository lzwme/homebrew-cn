cask "zeitgeist" do
  version "2.3"
  sha256 "437794ff91f9c8810580d1f07965b4100c28ef5fb162195bf8e87b5db7fd8308"

  url "https:github.comdanedenzeitgeistreleasesdownloadv#{version}Zeitgeist.app.zip",
      verified: "github.comdanedenzeitgeist"
  name "Zeitgeist"
  desc "Keep an eye on your Vercel deployments"
  homepage "https:zeitgeist.daneden.me"

  depends_on macos: ">= :big_sur"

  app "Zeitgeist.app"

  uninstall quit: "me.daneden.Zeitgeist"

  zap trash: [
    "~LibraryApplication Scriptsgroup.me.daneden.Zeitgeist.shared",
    "~LibraryApplication Scriptsme.daneden.Zeitgeist",
    "~LibraryContainersme.daneden.Zeitgeist",
    "~LibraryGroup Containersgroup.me.daneden.Zeitgeist.shared",
  ]
end