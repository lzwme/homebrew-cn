class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.31.0v2.31.0.tar.gz"
  sha256 "b96d55a6735dbcf788146590174243bad0bb49edc43215c38e63b6353be73dea"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ea8bc12ca16f5786a902409443114192333392229c8e87431ebd6baa41a381a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5347020c4cd483ea12471dd94cffce4d413c642c2c157f0e62fb04e47cba7ce5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88b278311dc1847b0b3904e1c22ee3fab0640224a277d736918c66fa1b609c2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f613dde6f1effa92d827c60b2358ddff17f584ace2d083f737b481a434515fa"
    sha256 cellar: :any_skip_relocation, ventura:        "1361b985202ce8d829f5b827691b3d6f6ea463af4cde7f4d66f4de9b1acf0ba8"
    sha256 cellar: :any_skip_relocation, monterey:       "670895916bc28e2731bcab3d34a0e45f2b769fa41e719e6203b7848b93adf2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41886f46ce15327193fe59a740ced43dd1af6ed08b8cc588748e1abb396f22e9"
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