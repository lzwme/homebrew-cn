class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:spicetify.app"
  url "https:github.comspicetifycliarchiverefstagsv2.40.9v2.40.9.tar.gz"
  sha256 "33ffbdebf1296db67089722b375ee4dc3f7e8708815cc11c40e1a499370f08b5"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a50809a3274c1b12cf74a900cf5d33f485a4318d6a8ae3ebf407a6acba4407ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a50809a3274c1b12cf74a900cf5d33f485a4318d6a8ae3ebf407a6acba4407ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a50809a3274c1b12cf74a900cf5d33f485a4318d6a8ae3ebf407a6acba4407ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8265ce504ecb129f08c546907599ae214c574e136e8fa10efa70e5686b6b419"
    sha256 cellar: :any_skip_relocation, ventura:       "e8265ce504ecb129f08c546907599ae214c574e136e8fa10efa70e5686b6b419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5889cda195202be9529539b0b344e412f9637b115d32b1aed56016903d582a5f"
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