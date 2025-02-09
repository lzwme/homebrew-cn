class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.39.2v2.39.2.tar.gz"
  sha256 "33a1681a667de9492a87085227cfd73aabe8aba9cf217728a74df8adc0a062bc"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "867015d482a93b8f675d92f6ff9e4787497fb94f719de599d1d50dafd08ff78b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "867015d482a93b8f675d92f6ff9e4787497fb94f719de599d1d50dafd08ff78b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "867015d482a93b8f675d92f6ff9e4787497fb94f719de599d1d50dafd08ff78b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bd1ae8630d8920a537a8584db387534843c60f9ab8af7e2f77e36e58481c900"
    sha256 cellar: :any_skip_relocation, ventura:       "0bd1ae8630d8920a537a8584db387534843c60f9ab8af7e2f77e36e58481c900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0380cdcf3a3950d42aad00979f76f7bfccdb6906e4c67d3d0e38fcdbb4aece4"
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