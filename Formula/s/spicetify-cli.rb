class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.36.7v2.36.7.tar.gz"
  sha256 "ee806f416a866b2060e1ebc00edf268686ac0da005650847c572db66a40e0a32"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "206c6bd712d32040465c9d6e5b8e9180475534dc19e3a7792dec3a90f898680d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8666880fd8e31355c12948dc41b303f3e6feff31b4c55cdbda37a41a78ff7548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf145d07731de979dc17c6b256a79d5c994f1962e7ea5ce5db393099622d5d07"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7cf0285aa6cc83bc03939e39a53d231dc4b58d7b8e0c75931e9db8659e884e9"
    sha256 cellar: :any_skip_relocation, ventura:        "454c5e38f9d9b0bcefac43d5567316abfaa407d081d83cc468c85376faca2831"
    sha256 cellar: :any_skip_relocation, monterey:       "e09210d3d136bb8faeb6d3811af5d8620635ef694bd9f8d6183e8a75191b2c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66f174bd446a2d17f72b1e991b1d3351b2ee008e13e8e18874dadcf00599b72"
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