cask "visit" do
  on_high_sierra :or_older do
    version "3.1.1"
    sha256 "4213daed23de17ee8bcfba779a96cce3ef92d3075ae666f7aeaffa824d484924"

    url "https:github.comvisit-davvisitreleasesdownloadv#{version}visit#{version}.darwin-x86_64-10.13.dmg",
        verified: "github.comvisit-davvisit"

    livecheck do
      skip "Legacy version"
    end
  end
  on_mojave :or_newer do
    version "3.4.1"
    sha256 "909f482c6a5e1777ede98d4c0a8019cd23f41ac0fde1eb58942ca99da84ef132"

    url "https:github.comvisit-davvisitreleasesdownloadv#{version}VisIt-#{version}.dmg",
        verified: "github.comvisit-davvisit"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  name "VisIt"
  desc "Visualisation and data analysis for mesh-based scientific data"
  homepage "https:wci.llnl.govsimulationcomputer-codesvisit"

  depends_on macos: ">= :high_sierra"

  app "VisIt.app"

  zap trash: "~LibrarySaved Application Stategov.llnl.visit.gui.savedState"
end