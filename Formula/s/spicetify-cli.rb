class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.36.4v2.36.4.tar.gz"
  sha256 "a274d1bdde675c7b352b5e8997b75c10445f0ec10f01ed6edbd6ab5bc40bd734"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb7a121ddc8d91a56f51fb41fd3a852a5f53eb9ceeed17b12cc2bbbdb58d6a72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2bb9771d14b1854130445ed122998e408237134043199c6a338a4442557c507"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b003022a45f240e78da29ae03eb2ae7d586a75f3dc09735c380bd96b2696e7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcab4ebe294b88c87833ef9c26a662f5616d03a994ff149f9738e59f516c73b1"
    sha256 cellar: :any_skip_relocation, ventura:        "9e64552bb6ba89fd13efd82c90d407d43efd7a92867268a812bcaa51880593d3"
    sha256 cellar: :any_skip_relocation, monterey:       "b671f29dbfc91cca5c8ff3fd96228f5bf0af2438f50bab78d85cad51668ab437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f652d05b093d315566325257e4b47470dc99f9cfe14f3e92f458f5299b502b9"
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