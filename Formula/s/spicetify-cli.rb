class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifycli"
  url "https:github.comspicetifycliarchiverefstagsv2.38.1v2.38.1.tar.gz"
  sha256 "461599334b3e85bec6001bbeb952d216fb8755f1ab0fa7ca73bc2bc8def91881"
  license "LGPL-2.1-only"
  head "https:github.comspicetifycli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd27979009c90d4d3cd032cd7e83115077c3bfdf7bd3de09180eabf55ca7a4ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd27979009c90d4d3cd032cd7e83115077c3bfdf7bd3de09180eabf55ca7a4ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd27979009c90d4d3cd032cd7e83115077c3bfdf7bd3de09180eabf55ca7a4ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3be39e481f2ac1db123d8fd2360dbafb058838b7ee018a50781738da8f52585"
    sha256 cellar: :any_skip_relocation, ventura:        "a3be39e481f2ac1db123d8fd2360dbafb058838b7ee018a50781738da8f52585"
    sha256 cellar: :any_skip_relocation, monterey:       "a3be39e481f2ac1db123d8fd2360dbafb058838b7ee018a50781738da8f52585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe95c4202863f6ff63cae6aa4ec70d8bfeda0800e0786bfcf7f7b02e7c55bb0"
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

    output = shell_output("#{bin}spicetify config current_theme 2>&1", 1)
    assert_match "com.spotify.Client is not a valid path", output
  end
end