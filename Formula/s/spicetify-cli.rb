class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.37.2v2.37.2.tar.gz"
  sha256 "b24a735fd9df596e3976662915f42e3d626ff99c1a908c91fb9c7a2df427f9a4"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "557e15ea6981ca1e8ca36fc6bb91a7e6fe0778c0539b783d38abe10643d1e751"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "557e15ea6981ca1e8ca36fc6bb91a7e6fe0778c0539b783d38abe10643d1e751"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "557e15ea6981ca1e8ca36fc6bb91a7e6fe0778c0539b783d38abe10643d1e751"
    sha256 cellar: :any_skip_relocation, sonoma:         "d064313a357545784b9823348ccb93d02146177ffb347194e2f351265e75458a"
    sha256 cellar: :any_skip_relocation, ventura:        "d064313a357545784b9823348ccb93d02146177ffb347194e2f351265e75458a"
    sha256 cellar: :any_skip_relocation, monterey:       "d064313a357545784b9823348ccb93d02146177ffb347194e2f351265e75458a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "975804fc5c5457fe33179a14282501166389f9530ddee522a542ffb5de7e1c96"
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