class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.36.8v2.36.8.tar.gz"
  sha256 "d401c8a0bfab1be253302f4281642eb8bd123298240fd71fd2f8c7bc0abf05ff"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b3848a0fb9e952e7651ee43b9d59684de0330cf34a7195d4bf4d38425dce1b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59304392f4ff697d7550ac33ec210973a0abd9d7c9181ff8b0b6436bb900b2e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e09df70597e7f7277ea44bcff185dae24b9d9a578412ab3d98f333bd7baa41"
    sha256 cellar: :any_skip_relocation, sonoma:         "e49cb639287472b3d66420b21573f0fce8e9c297d3f5d7b3ae06f8f7686f596f"
    sha256 cellar: :any_skip_relocation, ventura:        "b5d0a6323581acce2fe430a467dfb9a7ada3487482ac1b4671d1cd26890fbab2"
    sha256 cellar: :any_skip_relocation, monterey:       "aeb204107d8a431d8a4dcfe02a364522e46218bde2d6e99588ab33e2b392369b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98ae8ff18323d31123197ffb650c3aaf72662edd214c40100e6be006dc793571"
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