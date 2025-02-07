class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.39.0v2.39.0.tar.gz"
  sha256 "6c629263b4b0ee6ca3d008e547fa2ca198dd14f4a538dcc6d8f085f66d61ae98"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13f31f8c4da982f173919d5eb4cda2dd1aa78e23ec719cb602b6cb3c87309fe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13f31f8c4da982f173919d5eb4cda2dd1aa78e23ec719cb602b6cb3c87309fe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13f31f8c4da982f173919d5eb4cda2dd1aa78e23ec719cb602b6cb3c87309fe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff9038d7dc84e3380cfec544373b7b9114916e17071ae8c25bc9addf73f487c"
    sha256 cellar: :any_skip_relocation, ventura:       "7ff9038d7dc84e3380cfec544373b7b9114916e17071ae8c25bc9addf73f487c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b6ee455d84ba4acd4d795d0731527580ebe0bc23f2dad36d5e02540adbc1d5b"
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