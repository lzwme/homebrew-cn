class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:spicetify.app"
  url "https:github.comspicetifycliarchiverefstagsv2.40.7v2.40.7.tar.gz"
  sha256 "1d80637127ba66577e53014cf794d069346cf8051377d4085ce8d90a4ed44f71"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "384628f34a946747e55d9de2dbf23153d090db9b368444d0b43bfbf83ba34eb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "384628f34a946747e55d9de2dbf23153d090db9b368444d0b43bfbf83ba34eb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "384628f34a946747e55d9de2dbf23153d090db9b368444d0b43bfbf83ba34eb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "12fe28b9fa3d83a3a7d3b0a383d931085dc355b88345330e35b99f94f9f44d46"
    sha256 cellar: :any_skip_relocation, ventura:       "12fe28b9fa3d83a3a7d3b0a383d931085dc355b88345330e35b99f94f9f44d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd17c77a278506beaf1da3a0d167fd711d2f2f19cb3c3dcbe83182d39eda6f0"
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
    path.write <<~INI
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    INI

    quiet_system bin"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}spicetify -v")

    output = shell_output("#{bin}spicetify config current_theme 2>&1", 1)
    assert_match "com.spotify.Client is not a valid path", output
  end
end