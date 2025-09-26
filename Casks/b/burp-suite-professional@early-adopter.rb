cask "burp-suite-professional@early-adopter" do
  arch arm: "MacOsArm64", intel: "MacOsx"

  version "2025.9.3"
  sha256 arm:   "8ec7c8b641f37b9347f410d0b16ca9fbf5fb77d925a6dacc231fab2f2d715231",
         intel: "7c1a88a81e356e49c36a1e45615fafcc115859a05c61a807dd49aaaa7b1bb050"

  url "https://portswigger-cdn.net/burp/releases/download?product=pro&version=#{version}&type=#{arch}",
      verified: "portswigger-cdn.net/burp/releases/"
  name "Burp Suite Professional"
  desc "Web security testing toolkit"
  homepage "https://portswigger.net/burp/pro"

  livecheck do
    url "https://portswigger.net/burp/releases/data"
    strategy :json do |json|
      all_versions = json.dig("ResultSet", "Results")
      next if all_versions.blank?

      all_versions.filter_map do |item|
        item["version"] if
              item["releaseChannels"]&.include?("Early Adopter") &&
              item["categories"]&.include?("Professional") &&
              item["builds"]&.any? do |build|
                build["ProductPlatform"] == arch.to_s
              end
      end
    end
  end

  conflicts_with cask: "burp-suite-professional"

  app "Burp Suite Professional.app"

  zap trash: "~/.BurpSuite"
end