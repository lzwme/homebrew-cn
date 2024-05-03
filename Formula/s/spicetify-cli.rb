class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.36.10v2.36.10.tar.gz"
  sha256 "1d591cfb061a4ee7065db57828030dc1c85d5ae0dd3d9ef022350acd245bf98d"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50b1a0fcebc61314592bc7d98c4883d6c2124e4d84ab227b65ef2a685e8ff95e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa3b8b9ff84f7081045b0c310472dcf4eba347948b46083a0166ace457b53628"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "483c78bf5bf9861d0e92a445bbf9504030a863f8fe882fd87ed7788f780a16b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "b38697e3096633e45d4eaa351e08f3396a6c7479b6792af5fca7a9d45825ba59"
    sha256 cellar: :any_skip_relocation, ventura:        "1bfe32aa816a352b503eb9b5e8e418a01fe6c28789587780ae9280aea157de46"
    sha256 cellar: :any_skip_relocation, monterey:       "33214ec984d8f09446661125011cca5a3da4c52f3952688142195d4e53c38c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a2b3d2b37ea11a3775232908e0d976ff92a26993a0675b9abb465c2cc2cf9f"
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