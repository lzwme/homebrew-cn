cask "gitkraken-cli" do
  arch arm: "macOS_arm64", intel: "macOS_x86_64"

  version "2.1.2"
  sha256 arm:   "b5ddb317193dd544bc36ec56f64f03e17afee39b917caea5534cbdfcdd1df166",
         intel: "0f0b03609d756bd2c2338c5445c08e2c4db6f7f2bd9ce067230731d31a6b6fd4"

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