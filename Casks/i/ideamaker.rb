cask "ideamaker" do
  arch arm: "-arm64"
  livecheck_arch = on_arch_conditional arm: "apple_silicon", intel: "mac"

  version "5.1.4.8480"
  sha256 arm:   "209a3fa2282ae1f9f1f512c288634a23fa4aa41c4b06ab94ad85cb94ee6ac9ff",
         intel: "d7e8a504ce9a3620b96173b0b76a73b7d1bac943ec2f010cc4339de703b3da1a"

  url "https://downcdn.raise3d.com/ideamaker/release/#{version.major_minor_patch}/install_ideaMaker_#{version}#{arch}.dmg"
  name "ideaMaker"
  desc "FDM 3D Printing Slicer by Raise3D"
  homepage "https://www.raise3d.com/ideamaker/"

  livecheck do
    url "https://api.raise3d.com/ideamakerio-v1.1/hq/ofpVersionControl/find", post_json: {}
    regex(/install[._-]ideaMaker[._-]v?(\d+(?:\.\d+)+)#{arch}\.dmg/i)
    strategy :json do |json, regex|
      match = json.dig("data", "release_version", "#{livecheck_arch}_url")&.match(regex)
      next if match.blank?

      match[1]
    end
  end

  depends_on macos: ">= :catalina"

  app "ideaMaker.app"

  zap trash: [
    "~/Library/Application Support/ideaMaker",
    "~/Library/Preferences/com.raise3d.ideaMaker.plist",
    "~/Library/Saved Application State/com.raise3d.ideaMaker.savedState",
  ]
end