class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.37.0v2.37.0.tar.gz"
  sha256 "757df34545a60b5696a0d513a5a0a258b0e56ba6766645ee53a1fab8e5c6b29a"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6c686d723031952ed26f6062a13957a51bd16c75fcfd737de4da4879604bbf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d947c4c3013c7a58f31e4461306a31e32958bf80449db3d04cb0e8159207816"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d947b48b420a8b89c6bca158aaf5e9f74c267ab187a4eefbba5e5544c5e255"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3936794d9f4f659637ed2f2c847fa3a1862c3c5d1e5011447b4eef5b374c173"
    sha256 cellar: :any_skip_relocation, ventura:        "ff33eb5b79112e9f5a9b04e83c04a19e8cf4e2d71a1f11329fac65bb4f17d709"
    sha256 cellar: :any_skip_relocation, monterey:       "0c7118678e4ce107adbb1c3e68b606543eb588b965aa105507f37ffcbf392f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a41c6a9134500bb1456a4e06dc7ef6f7388952930d2418a9bacb4ab0b329a26"
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