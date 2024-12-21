class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.38.6v2.38.6.tar.gz"
  sha256 "22a19a8ee4791f57aec7f2ac3eb497575632c519e94bbd77d0ee67a1e95afc2c"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564ca68af6702d69219131c24050c857672ab93c37db8a83899e50affd69a3ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "564ca68af6702d69219131c24050c857672ab93c37db8a83899e50affd69a3ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "564ca68af6702d69219131c24050c857672ab93c37db8a83899e50affd69a3ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "f70a93721de6c15438f8b9f82ce9b97d1c8bcb195f7b1ff212659ee297230a4a"
    sha256 cellar: :any_skip_relocation, ventura:       "f70a93721de6c15438f8b9f82ce9b97d1c8bcb195f7b1ff212659ee297230a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "237266e81a97fad0cbebd8e787ad401f1ae138ba3d5dcc9e3f3810328c2d6993"
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