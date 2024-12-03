class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.38.5v2.38.5.tar.gz"
  sha256 "bb72f491552d0f8fbe0ab3195c70884e8c4eb9c588f17ec77dcb4494aec70e52"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2df4534c78f9d0e1852ed4ffe5c6a817435c830366178fa9236101b92636d24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2df4534c78f9d0e1852ed4ffe5c6a817435c830366178fa9236101b92636d24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2df4534c78f9d0e1852ed4ffe5c6a817435c830366178fa9236101b92636d24"
    sha256 cellar: :any_skip_relocation, sonoma:        "25a2ecef3ac866295c5386bfea61ae9446b2e5e13dc353832ce1262792778274"
    sha256 cellar: :any_skip_relocation, ventura:       "25a2ecef3ac866295c5386bfea61ae9446b2e5e13dc353832ce1262792778274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c4090c96da50c73cd4f8f2fc0581d99feace82548d12886263efeb920bd92a3"
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