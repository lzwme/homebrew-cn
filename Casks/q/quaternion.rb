cask "quaternion" do
  version "0.0.97"
  sha256 "b935c8f026edc9dd72a6d4cfc27479c58c5b102c509e3b84a0faee20af941785"

  url "https:github.comquotient-imQuaternionreleasesdownload#{version}quaternion-#{version}.dmg"
  name "Quaternion"
  desc "IM client for Matrix"
  homepage "https:github.comquotient-imQuaternion"

  livecheck do
    url :url
    regex(^quaternion[._-]v?(\d+(?:\.\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  depends_on macos: ">= :catalina"

  app "quaternion.app"

  zap trash: [
    "~LibraryApplication SupportQuotientquaternion",
    "~LibraryContainerscom.github.quaternion",
    "~LibraryPreferencescom.github.quaternion.plist",
    "~LibraryPreferencescom.qmatrixclient.quaternion.plist",
    "~LibraryPreferencescom.quotient.quaternion.plist",
    "~LibrarySaved Application Statecom.github.quaternion.savedState",
  ]
end