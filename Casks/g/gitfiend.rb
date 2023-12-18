cask "gitfiend" do
  version "0.44.3"
  sha256 "ad06ff9c0247993a9ec9aa4bb93b880662097742072cd4ff1cc302b621e4cadc"

  url "https:gitfiend.comresourcesGitFiend-#{version}.dmg"
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