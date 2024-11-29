cask "wezterm" do
  version "20240203-110809,5046fc22"
  sha256 "e77388cad55f2e9da95a220a89206a6c58f865874a629b7c3ea3c162f5692224"

  url "https:github.comwezweztermreleasesdownload#{version.csv.first}-#{version.csv.second}WezTerm-macos-#{version.csv.first}-#{version.csv.second}.zip",
      verified: "github.comwezwezterm"
  name "WezTerm"
  desc "GPU-accelerated cross-platform terminal emulator and multiplexer"
  homepage "https:wezfurlong.orgwezterm"

  livecheck do
    url :url
    regex(^(\d+(?:[.-]\d+)+)-(\h+)$i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  conflicts_with cask: "wezterm@nightly"

  app "WezTerm-macos-#{version.csv.first}-#{version.csv.second}WezTerm.app"
  %w[
    wezterm
    wezterm-gui
    wezterm-mux-server
    strip-ansi-escapes
  ].each do |tool|
    binary "#{appdir}WezTerm.appContentsMacOS#{tool}"
  end

  binary "#{appdir}WezTerm.appContentsResourcesshell-completionzsh",
         target: "#{HOMEBREW_PREFIX}sharezshsite-functions_wezterm"
  binary "#{appdir}WezTerm.appContentsResourcesshell-completionbash",
         target: "#{HOMEBREW_PREFIX}etcbash_completion.dwezterm"
  binary "#{appdir}WezTerm.appContentsResourcesshell-completionfish",
         target: "#{HOMEBREW_PREFIX}sharefishvendor_completions.dwezterm.fish"

  zap trash: [
    "~.localsharewezterm",
    "~LibrarySaved Application Statecom.github.wez.wezterm.savedState",
  ]
end