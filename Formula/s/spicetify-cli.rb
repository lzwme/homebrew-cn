class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.42.11/v2.42.11.tar.gz"
  sha256 "f1b8fc1ed32a128d9d432971085c6d698eaf31f70d8294c349607eba74a3108f"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26ca861081bb377d64dc8aa82d282b6a6060dbc8baa6154ed32619a456c05ffa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26ca861081bb377d64dc8aa82d282b6a6060dbc8baa6154ed32619a456c05ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ca861081bb377d64dc8aa82d282b6a6060dbc8baa6154ed32619a456c05ffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "825bc67f00d6affef1086e9a8445c83e6874e05e40d4eedc6fbb7ef02fcd181c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "878262c271d4c6ca7676a5e06099bf14a3af3501da897bc03a7cded6a403a1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb6a300cdbefb9365b35f908da840484dc5ab991f18e8715abea4f972efab2c8"
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