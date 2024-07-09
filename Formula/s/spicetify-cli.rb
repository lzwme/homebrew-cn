class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.36.14v2.36.14.tar.gz"
  sha256 "3a00f2411586279c3067ee5c076773365c9d4093b0f5121b14431d6d19f51e56"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d27b5c2a2529b3c63e63f7bb0001f39d72b5ce6fdf76b056e6f94cb4f2bd450"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa0d104a3364f18e5adfd6f568f33ee8239fd84465437d67c3ba605a023d9d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69153159268941bcea08bfd7942fdd7d9f3b80ae14a0cc60b36fc08918d6f6cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "420b73627ef5ec9e4996a1b161b8d3260b373eb5f367a295e4c67d62f9f995c8"
    sha256 cellar: :any_skip_relocation, ventura:        "39037d2a5e90e04555f2d6b574c28c6993ae27110dee3a080259762cfde6292a"
    sha256 cellar: :any_skip_relocation, monterey:       "c7e9d3bf3d5925eed9264fa2867f98353568a03ac77c015347985b6d74642e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7528228c9f54b611fc94c5503d97b107cdd70cfef0a43533e3ecfdb6574de016"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec"spicetify")
    cd buildpath do
      libexec.install [
        "css-map.json",
        "CustomApps",
        "Extensions",
        "globals.d.ts",
        "jsHelper",
        "Themes",
      ]
      bin.install_symlink libexec"spicetify"
    end
  end

  test do
    spotify_folder = testpath"com.spotify.Client"
    pref_file = spotify_folder"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file
    path = testpath".configspicetifyconfig-xpui.ini"
    path.write <<~EOS
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    EOS
    quiet_system bin"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}spicetify -v")
    assert_match "SpicetifyDefault", shell_output("#{bin}spicetify config current_theme")
  end
end