class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:spicetify.app"
  url "https:github.comspicetifycliarchiverefstagsv2.39.4v2.39.4.tar.gz"
  sha256 "e6b4b15f05146098df27d93a8662fee646fe1e8cf227ae62cc73a0c2a3b235e5"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc7c59bbb020ac115152318311d63bc63f3db4c8c4990cd550fab212d6f63a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edc7c59bbb020ac115152318311d63bc63f3db4c8c4990cd550fab212d6f63a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edc7c59bbb020ac115152318311d63bc63f3db4c8c4990cd550fab212d6f63a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fe3c1076807b8ab427acd7c168b56781217624a7b8e49033b20db0cbcafb03f"
    sha256 cellar: :any_skip_relocation, ventura:       "9fe3c1076807b8ab427acd7c168b56781217624a7b8e49033b20db0cbcafb03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7257c4a2ad250e54dd554966a021dad170ecf6ec0b7300599db817191f55a7"
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