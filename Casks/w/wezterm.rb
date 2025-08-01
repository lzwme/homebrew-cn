cask "wezterm" do
  version "20240203-110809,5046fc22"
  sha256 "e77388cad55f2e9da95a220a89206a6c58f865874a629b7c3ea3c162f5692224"

  url "https://ghfast.top/https://github.com/wezterm/wezterm/releases/download/#{version.csv.first}-#{version.csv.second}/WezTerm-macos-#{version.csv.first}-#{version.csv.second}.zip",
      verified: "github.com/wezterm/wezterm/"
  name "WezTerm"
  desc "GPU-accelerated cross-platform terminal emulator and multiplexer"
  homepage "https://wezterm.org/"

  livecheck do
    url :url
    regex(/^(\d+(?:[.-]\d+)+)-(\h+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  no_autobump! because: :requires_manual_review

  conflicts_with cask: "wezterm@nightly"

  app "WezTerm-macos-#{version.csv.first}-#{version.csv.second}/WezTerm.app"
  %w[
    wezterm
    wezterm-gui
    wezterm-mux-server
    strip-ansi-escapes
  ].each do |tool|
    binary "#{appdir}/WezTerm.app/Contents/MacOS/#{tool}"
  end

  bash_completion "#{appdir}/WezTerm.app/Contents/Resources/shell-completion/bash", target: "wezterm"
  fish_completion "#{appdir}/WezTerm.app/Contents/Resources/shell-completion/fish", target: "wezterm.fish"
  zsh_completion "#{appdir}/WezTerm.app/Contents/Resources/shell-completion/zsh", target: "_wezterm"

  zap trash: [
    "~/.local/share/wezterm",
    "~/Library/Saved Application State/com.github.wez.wezterm.savedState",
  ]
end