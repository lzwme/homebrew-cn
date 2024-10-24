class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v0.38.0/sequoia-sq-v0.38.0.tar.gz"
  sha256 "9fd32ad0de3388804e21205003821710d2faf99d5c85a50bd97da3e7e480921b"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "755883385b8e76d746a2b650ea666c452a48155827b7b2ec4954ee04cac25ae5"
    sha256 cellar: :any,                 arm64_sonoma:  "befeb6ebd04855f7ea0f39e9174a37764cc8b04c44a41a8f8a1c93e41da2c347"
    sha256 cellar: :any,                 arm64_ventura: "a5f1dc477dd1d5efedf1a359551459ca8df2512a728eb0c0a7b541f3131209c4"
    sha256 cellar: :any,                 sonoma:        "0bb7808ed663609eb3b0da94ed3913584b5d328727c22fcde1675f90607f06ba"
    sha256 cellar: :any,                 ventura:       "5424e7caa7d7251310915c59f44495389759e537134cccd537faa3aeba41ff04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "796d6f2f76734d83ce360fc3c985cacbf0ca2e860154d6f912bfc495c9b80048"
  end

  depends_on "capnp" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "gmp"
  depends_on "nettle"
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["ASSET_OUT_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args
    man1.install Dir["man-pages/*.1"]

    bash_completion.install "shell-completions/sq.bash"
    zsh_completion.install "shell-completions/_sq"
    fish_completion.install "shell-completions/sq.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sq version 2>&1")
    assert_match "R0lGODdhAQABAPAAAAAAAAAAACwAAAAAAQABAAACAkQBADs=",
      shell_output("cat #{test_fixtures("test.gif")} | #{bin}/sq toolbox armor")
  end
end