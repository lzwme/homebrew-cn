class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https:github.comspicetifyspicetify-cli"
  url "https:github.comspicetifyspicetify-cliarchiverefstagsv2.30.0v2.30.0.tar.gz"
  sha256 "d40a1452bfdfd462c55b3b71ddaa18106811ba55ab9b05cf375fe0f217b33941"
  license "LGPL-2.1-only"
  head "https:github.comspicetifyspicetify-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c720f2173910efc63f69f848b5c2a2903f20bd7474d2782d63b83cf1c183b0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f94e1e03d4dbdc1e840771f859acb8d9193eb175b4d747962aba5bb99c8d7107"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfac86bcf2d1c55b3cda3af6c6293c33f769a0986cab84c1edfb50d8a624b914"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c06f1b0be5c424bbf275a244882f76378cb1e234efce723e092d27b3d70debc"
    sha256 cellar: :any_skip_relocation, ventura:        "eaecb000f1db5e0e8e083b5100424931b4f515be8ae6f488a4271caae363cc74"
    sha256 cellar: :any_skip_relocation, monterey:       "a6d810f91b02d54d9802e33c8db9e8994dbd9139080c0e029efc328f5134d899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b3ce5ddbe95a32777739da1732fc4cf34d7bceda572dbe1cb81f0138dae026b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec"spicetify")
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