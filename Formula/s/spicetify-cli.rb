class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://ghfast.top/https://github.com/spicetify/cli/archive/refs/tags/v2.45.0/v2.45.0.tar.gz"
  sha256 "2e17c15a92093c62d011acd863f36148f8d5880292cadf41949eda320fd033c3"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35545746bfc06acab51c3d296a46ed7bd572e32cabeca110813ced9d33fde9e9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35545746bfc06acab51c3d296a46ed7bd572e32cabeca110813ced9d33fde9e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35545746bfc06acab51c3d296a46ed7bd572e32cabeca110813ced9d33fde9e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "35545746bfc06acab51c3d296a46ed7bd572e32cabeca110813ced9d33fde9e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d56d6f88359901f9d17d30e17363068a28af63cde9c3888b8f2e61b1678ea37"
    sha256 cellar: :any,                 x86_64_linux:      "f278f22dd2fb28bf8b9d5fe018f268657bd4993f78dfd02ce1216cf814b63478"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: libexec/"spicetify")

    system "pnpm", "with", "current", "install", "--frozen-lockfile"
    system "pnpm", "with", "current", "run", "build:wrapper"

    libexec.install [
      "css-map.json",
      "CustomApps",
      "Extensions",
      "globals.d.ts",
      "jsHelper",
      "Themes",
    ]
    bin.install_symlink libexec/"spicetify"
  end

  test do
    spotify_folder = testpath/"com.spotify.Client"
    pref_file = spotify_folder/"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file

    path = testpath/".config/spicetify/config-xpui.ini"
    path.write <<~INI
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    INI

    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")

    output = shell_output("#{bin}/spicetify config current_theme")
    assert_match "SpicetifyDefault", output
  end
end