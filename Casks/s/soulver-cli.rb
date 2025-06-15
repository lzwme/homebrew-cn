cask "soulver-cli" do
  version "1.0.2"
  sha256 "98ea4692b3e9def0aec041f3fdff19d20aa606a775c44364a2a5fd98babdd2f3"

  url "https:github.comsoulverteamSoulver-CLIreleasesdownload#{version}soulver.zip"
  name "Soulver CLI"
  desc "Standalone cli for the Soulver calculation engine"
  homepage "https:github.comsoulverteamSoulver-CLI"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :monterey"

  binary "soulver"

  zap trash: "#{HOMEBREW_PREFIX}SoulverCore_SoulverCore.bundle"
end