class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.37.7v2.37.7.tar.gz"
  sha256 "d6cefd9a2e64a544870701f278e041930f5621024b894dea7ef3d9466b9063f7"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d137be9515e4535fb20e57d31aa6cc12aa9cf77c1ab73133ab416b02e2d9613"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d137be9515e4535fb20e57d31aa6cc12aa9cf77c1ab73133ab416b02e2d9613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d137be9515e4535fb20e57d31aa6cc12aa9cf77c1ab73133ab416b02e2d9613"
    sha256 cellar: :any_skip_relocation, sonoma:         "eef71f65fae0108eeeee6f6c57e5da66c1355bd6afe6b8661a46bdc1e6c18ecc"
    sha256 cellar: :any_skip_relocation, ventura:        "eef71f65fae0108eeeee6f6c57e5da66c1355bd6afe6b8661a46bdc1e6c18ecc"
    sha256 cellar: :any_skip_relocation, monterey:       "eef71f65fae0108eeeee6f6c57e5da66c1355bd6afe6b8661a46bdc1e6c18ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87f6cbc0300289ad1e881a340b44597c1ef3997de44d6d26cdd61243679a5b28"
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