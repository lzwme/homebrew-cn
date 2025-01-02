class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v1.1.0/sequoia-sq-v1.1.0.tar.gz"
  sha256 "3316902e1f52e8f01829b72014bda006ad9712ec3802703d395dbc6dbf50cb9d"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d73c1b0a6e474b0a885f6271fdc5d5c1f7f1b2dbad38b67b8c50cbc0064e224b"
    sha256 cellar: :any,                 arm64_sonoma:  "306685b1b8fd0924658f95b5fba19731d94d1f99071fbdf1f0c3b2a77a217b2d"
    sha256 cellar: :any,                 arm64_ventura: "09d95276fb677ce79400340a9c1fd18d389d5bf009d8fe9b008a14f586864a18"
    sha256 cellar: :any,                 sonoma:        "54b7376e5c4c6a722d0f3b4b1d16a8d2ac91f1811f94e6b08b6d716543657848"
    sha256 cellar: :any,                 ventura:       "ed05f653041ea5852c741aa748e34ba3afdeabfb4deab9cc62ebe9d9e4c7543a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77af122f45c1cd8174e7d977702c70b5de83a474ee5d71bfe12a60395c4a3168"
  end

  depends_on "capnp" => :build
  depends_on "pkgconf" => :build
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
      shell_output("cat #{test_fixtures("test.gif")} | #{bin}/sq packet armor")
  end
end