cask "gitkraken-cli" do
  arch arm: "macOS_arm64", intel: "macOS_x86_64"

  version "2.0.1"
  sha256 arm:   "0976d7404a370b2f21848012a55094bc0aca6860eed57f3b0d5059c527c51451",
         intel: "ecab735e3358bf76c9064d601d08cf00fee7875fbde8437aba1b15b892548c04"

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