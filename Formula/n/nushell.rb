class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.100.0.tar.gz"
  sha256 "00b94984d3140e286e06d4beca2926ef80e0a0cc3ada75916e4fb9fa66ec28ad"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c64c40787d7f86a2624578665b4c0ff85b1f178ceed5317865e98e67e611692"
    sha256 cellar: :any,                 arm64_sonoma:  "5e411c48e436dc5c9f248817e0e26e84a2b9c82267f02f4aba56e021018d7b40"
    sha256 cellar: :any,                 arm64_ventura: "2c1f7209af58d594a8cccc21dbdf0b2505c41d36e021f877e97852d57e806cfb"
    sha256 cellar: :any,                 sonoma:        "a2bee87a4957c6ba06773834f004c6138ccbb47da137acfd6676429c3ee3a63e"
    sha256 cellar: :any,                 ventura:       "2bb9097ab6d213cb03702a3e0b855cc384a26d4af7aaed685fc15e712b300b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "056d17777cad32b565f7f94c6dc81274e6b8e1746339808b23fbb24d5c3b7b21"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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