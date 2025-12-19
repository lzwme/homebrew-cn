class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.42.6/v2.42.6.tar.gz"
  sha256 "3643bda0fda5b3d6dd9437f6d3f357a946a7490e57a458565de6df965ea03d19"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b20e14b9e0e577283a4a493b582fb7271efdc48dd907cc32b217c5b9cdb49a2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b20e14b9e0e577283a4a493b582fb7271efdc48dd907cc32b217c5b9cdb49a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20e14b9e0e577283a4a493b582fb7271efdc48dd907cc32b217c5b9cdb49a2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "32b69f29c8db06740d00a052c8fae8aeeef48ae453796e35dc9fe34f27171b10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7ed80f358d913a488deb35801483082635579522d4ea3fd838aba7bc693afd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d30ab076dc030700e7364a5003bf9493c019c2c6cebfca42b28b429c00bd7c51"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"spicetify")
    cd buildpath do
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