class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.39.3v2.39.3.tar.gz"
  sha256 "8f29e98d8c666e0c3910b13e4203c1362fe4786bd144c28f149cb6fc67c2da5b"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac84c249f275ca8f95315fe479dc1763c474fb16a756b8636138e66672a60a86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac84c249f275ca8f95315fe479dc1763c474fb16a756b8636138e66672a60a86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac84c249f275ca8f95315fe479dc1763c474fb16a756b8636138e66672a60a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "be337fb96fd7937f72ee82a833763564342b457ca535a1d3dd742b823ca8ebc9"
    sha256 cellar: :any_skip_relocation, ventura:       "be337fb96fd7937f72ee82a833763564342b457ca535a1d3dd742b823ca8ebc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ea56dc0adaa34d3e03f562e5a5689a36b5a35e97d27462795d11f8f63d904c9"
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