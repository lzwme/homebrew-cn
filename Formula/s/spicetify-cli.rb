class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.37.4v2.37.4.tar.gz"
  sha256 "03a0e8b47d6e69476e288df80f380ca7944c107b452b3241f2f2d8cfbc1295fa"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acaf4ee138e3bc327df6a61d26f1f64b1407c3ef9abeccecb0b2b6bea2d3c334"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acaf4ee138e3bc327df6a61d26f1f64b1407c3ef9abeccecb0b2b6bea2d3c334"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acaf4ee138e3bc327df6a61d26f1f64b1407c3ef9abeccecb0b2b6bea2d3c334"
    sha256 cellar: :any_skip_relocation, sonoma:         "3920ded90b06f0b1b816b823441924199ce1dd4ea226ad30ce67b6906d6b73d0"
    sha256 cellar: :any_skip_relocation, ventura:        "3920ded90b06f0b1b816b823441924199ce1dd4ea226ad30ce67b6906d6b73d0"
    sha256 cellar: :any_skip_relocation, monterey:       "3920ded90b06f0b1b816b823441924199ce1dd4ea226ad30ce67b6906d6b73d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a45212a43772a79bc5095916af2f09ca3750a0cee5510aebc0346680354a71"
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