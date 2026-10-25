class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.46.3/v2.46.3.tar.gz"
  sha256 "f916bb9319b3d144cbe5b6b3f9a40e13b2d924c0598ca3c2c049ce3d80d7dfb8"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53b4c2e3ad512f88893a8690948aeaf25bf776ffc8490bb0b27bde51514e8127"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "53b4c2e3ad512f88893a8690948aeaf25bf776ffc8490bb0b27bde51514e8127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53b4c2e3ad512f88893a8690948aeaf25bf776ffc8490bb0b27bde51514e8127"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c031c3aaaca80b91b752c5ce26d433397397e15cab42532d4c5ac594a6269aaf"
    sha256 cellar: :any,                 x86_64_linux:      "e9d00babb3f082333b2e3b1d5c891b428bb32718483bda52c7a24aad8f8cd431"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "pnpm", "with", "current", "install", "--frozen-lockfile"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: libexec/"spicetify")

    system "pnpm", "--offline", "with", "current", "run", "build:wrapper"

    libexec.install [
      "css-map.json",
      "CustomApps",
      "Extensions",
      "globals.d.ts",
      "jsHelper",
      "Themes",
    ]
    bin.install_symlink libexec/"spicetify"
  end

  test do
    spotify_folder = testpath/"com.spotify.Client"
    pref_file = spotify_folder/"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file

    path = testpath/".config/spicetify/config-xpui.ini"
    path.write <<~INI
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    INI

    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")

    output = shell_output("#{bin}/spicetify config current_theme")
    assert_match "SpicetifyDefault", output
  end
end