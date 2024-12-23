class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.101.0.tar.gz"
  sha256 "43e4a123e86f0fb4754e40d0e2962b69a04f8c2d58470f47cb9be81daabab347"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bb9d218c5b51e968889c01cce460247447435931cc262d31132186123222795"
    sha256 cellar: :any,                 arm64_sonoma:  "7e22a7f35f719451550a5215e48c0a790c4f6ee131b95aaefe2eab4bfec711af"
    sha256 cellar: :any,                 arm64_ventura: "ecab162474927df0ab0dc8523051ae985ae00cf4e1d28ee09f24722c6af31a17"
    sha256 cellar: :any,                 sonoma:        "286497ceeceef61bbb741b604436a58aeb6617759b633e9b2c493e0b1e13adbc"
    sha256 cellar: :any,                 ventura:       "ec10a148f2ca83c9d8ab882f17300dab3ed8c900004e9e7b6fd146ceaa18c58f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97651e754bec060417fedc08c736dc0265d9652a1504c8126800b22e6d544c4c"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

    buildpath.glob("cratesnu_plugin_*").each do |plugindir|
      next unless (plugindir"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end