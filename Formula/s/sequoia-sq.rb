class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v1.0.0/sequoia-sq-v1.0.0.tar.gz"
  sha256 "ffbc8f61daddce8c3369bbfb36361debb38b21b035f4a321772d5dff19491ef6"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6899032138cce8334beda6dfe51de1f6a3b78389bc2c7a962b331880f15e306"
    sha256 cellar: :any,                 arm64_sonoma:  "a03f6386eda0cf4913052c2ec529953a1b6ab315ae367a07fa150b1f34b90875"
    sha256 cellar: :any,                 arm64_ventura: "8a1a517fdf1494dc41d7490f791db35490a4f070b7954209d45082580d44ba3d"
    sha256 cellar: :any,                 sonoma:        "912c5c8ac877949a15a0903ab87b5482eb752d0facca522b3af64361389ccf85"
    sha256 cellar: :any,                 ventura:       "e9c91a625b7f6f8f54761f168e4f6bf04ca5fcfdef2ce59cdbc6801210b143e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "888c4410499028b7032991afa7e50d49d1b02ac7029fbbac567e3334e65e1033"
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