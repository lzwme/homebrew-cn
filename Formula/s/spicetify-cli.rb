class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:spicetify.app"
  url "https:github.comspicetifycliarchiverefstagsv2.40.1v2.40.1.tar.gz"
  sha256 "ef8d5c45c55083eaeb0734594148c59d741c1f61646fa4198c5550a1e90ed9f9"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4c63b7d437e7dee369d8a6d955d7e02b1e0c31a1a677d29fc2e8b81dc361c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4c63b7d437e7dee369d8a6d955d7e02b1e0c31a1a677d29fc2e8b81dc361c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e4c63b7d437e7dee369d8a6d955d7e02b1e0c31a1a677d29fc2e8b81dc361c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3021416f70ae6fa7ed5a9a719c6ce0d3be9f3d55e98104f4ba9d364500367786"
    sha256 cellar: :any_skip_relocation, ventura:       "3021416f70ae6fa7ed5a9a719c6ce0d3be9f3d55e98104f4ba9d364500367786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e37ce6719aa9ce5f44a4cd3437518e7a645cacb65fb4e03aad9f19a90cedea84"
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