cask "gitkraken-cli" do
  arch arm: "macOS_arm64", intel: "macOS_x86_64"

  version "2.1.0"
  sha256 arm:   "4c6adb3f271032525b66d55e3d57cdc54bb7d9f41ddc6057d65a56cacf64a2b6",
         intel: "1b8da326401e534c40ce10a608111c55210316389dcd7f879b2aae0ea781e58d"

  url "https:github.comgitkrakengk-clireleasesdownloadv#{version}gk_#{version}_#{arch}.zip"
  name "GitKraken CLI"
  desc "CLI for GitKraken"
  homepage "https:github.comgitkrakengk-cli"

  binary "gk"
  binary "gk.bash",
         target: "#{HOMEBREW_PREFIX}etcbash_completion.dgk"
  binary "_gk",
         target: "#{HOMEBREW_PREFIX}sharezshsite-functions_gk"
  binary "gk.fish",
         target: "#{HOMEBREW_PREFIX}sharefishvendor_completions.dgk.fish"

  zap trash: "~.gitkraken"
end