cask "gitfiend" do
  arch arm: "-arm64"

  version "0.45.3"
  sha256 arm:   "f23c033b28516c6160566439d3217bb8d350dcf2441e29ac629219c6b42a54c5",
         intel: "bff456d1b422c1a40e61fdb8555736740974bee8fc37c17dd693f70bab3872e8"

  url "https:github.comGitFiendSupportreleasesdownloadv#{version}GitFiend-#{version}#{arch}.dmg",
      verified: "github.comGitFiendSupport"
  name "GitFiend"
  desc "Git client"
  homepage "https:gitfiend.com"

  livecheck do
    url "https:gitfiend.comapp-info"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "GitFiend.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}gitfiend.wrapper.sh"
  binary shimscript, target: "gitfiend"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}GitFiend.appContentsMacOSGitFiend' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportGitFiend",
    "~LibraryPreferencescom.tobysuggate.gitfiend.plist",
    "~LibrarySaved Application Statecom.tobysuggate.gitfiend.savedState",
  ]
end