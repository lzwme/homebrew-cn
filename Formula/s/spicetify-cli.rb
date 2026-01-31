class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.42.8/v2.42.8.tar.gz"
  sha256 "d13e11f3614bf5b79115376673041df888277d0905a6c2d7fb3080a9d63f296e"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d963a9b82de36f6ebf9a1672d7a1626664aa3698f1c9817bf9044235b83b6997"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d963a9b82de36f6ebf9a1672d7a1626664aa3698f1c9817bf9044235b83b6997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d963a9b82de36f6ebf9a1672d7a1626664aa3698f1c9817bf9044235b83b6997"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce78df1000476db92e6551be6c07908c7fce69ebe332f374425e714c73c2b689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f432b6e0a05c41553ce348239adfd431f1dec074a81820a7352ae9c19fa2ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f0433ff9cf0177711ebf64160b19935da613f2cab459b26ba592f5a08ab35c3"
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