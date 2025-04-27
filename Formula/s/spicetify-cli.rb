class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:spicetify.app"
  url "https:github.comspicetifycliarchiverefstagsv2.40.5v2.40.5.tar.gz"
  sha256 "0dc22f81a8d66c2c13fa4bd3af7434c3970b55643d27d1325e4f5eeb3b1da1b0"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f74211fb2ceacc679392420128d574fa97d3fd2586646e799732678e3012328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f74211fb2ceacc679392420128d574fa97d3fd2586646e799732678e3012328"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f74211fb2ceacc679392420128d574fa97d3fd2586646e799732678e3012328"
    sha256 cellar: :any_skip_relocation, sonoma:        "832bf9889a0c502ebca92a95cd1058d5e2046c5155480e6eec9d0ccad224146c"
    sha256 cellar: :any_skip_relocation, ventura:       "832bf9889a0c502ebca92a95cd1058d5e2046c5155480e6eec9d0ccad224146c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade8b52a8b81e3cef0f0c0a876db310000aa64322624e114c22af073b302789c"
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