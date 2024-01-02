class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.29.1v2.29.1.tar.gz"
  sha256 "a4bbde6424c36f5a9761f7d112ee729c0d52c1c113ed3d2e6234c6d8668ab0cb"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb1821cf3df1502b113e253049fdcbcd1502668d96b71a61b3f3c452ddbca9b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d8bc823ec83d57736f703462bc2452d156c8bb30a50485dcaf1a1aaec4056b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3fb15ef779323d8f56d115dd449ef74c0cd9958e4c821954cdb5922790c7985"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f67f6ae41edf071e597e7aa22ebc1076ca8e60f40ff751553488547c3526d92"
    sha256 cellar: :any_skip_relocation, ventura:        "9cdfb211f6d926987c7a4c1a6b2297161a3f61ecf08cfc48b77f8a6864f83245"
    sha256 cellar: :any_skip_relocation, monterey:       "784075182568b7ae642c67490eeabb137c64efe2b019ca372d9b08d83a1947c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ec7e23f20a20430a86ca629636e02c7636eed73b1621b112a0cc9a1b800ce9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec"spicetify")
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