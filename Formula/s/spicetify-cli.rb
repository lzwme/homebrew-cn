class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.45.3/v2.45.3.tar.gz"
  sha256 "f9620d6fdc1fabed82912b2e77042b14896b53de19a2a73d7565ebfd13082bfd"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b31f2e771c7bb6210655b580bb94a4e3370960d8024a33218844ee0739cd9369"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b31f2e771c7bb6210655b580bb94a4e3370960d8024a33218844ee0739cd9369"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b31f2e771c7bb6210655b580bb94a4e3370960d8024a33218844ee0739cd9369"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4472c1f6a0e1176e3c9ff9e748ecc256b46a72735aea957a0c24cbc4c375ce47"
    sha256 cellar: :any,                 x86_64_linux:      "e13337bb747cdde277bb72820de7c7c43680d4d534dc9926726b0d2d6df9f272"
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