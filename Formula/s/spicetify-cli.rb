class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:spicetify.app"
  url "https:github.comspicetifycliarchiverefstagsv2.39.5v2.39.5.tar.gz"
  sha256 "38a9b85b9d39e5be911f05e63fb037686ee2105639dbb5ec1190979bc423f5b0"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8317b8efe208e687a579cb876ab671d790ee638eccf2af95b86186672614599c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8317b8efe208e687a579cb876ab671d790ee638eccf2af95b86186672614599c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8317b8efe208e687a579cb876ab671d790ee638eccf2af95b86186672614599c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8157969dc2ad944eb96caf1ac946aa6d6f34ed34e3205776b0ebb00fd777307"
    sha256 cellar: :any_skip_relocation, ventura:       "a8157969dc2ad944eb96caf1ac946aa6d6f34ed34e3205776b0ebb00fd777307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ea9173c9c3b1e9b2ce042135af64023176ac206b34654b70390bbd0a501c22"
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