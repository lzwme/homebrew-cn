class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v0.39.0/sequoia-sq-v0.39.0.tar.gz"
  sha256 "ee63c606adbfedeb32fbeacb522eac0f6a0a7358710da21fc602b2f8f74f7726"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "399f0eb12f7826faa46c840654c4f30dd72a9a4aa73a588349561580d7909a33"
    sha256 cellar: :any,                 arm64_sonoma:  "d226bb9a3faf7e65153e78e0b9e5e93b5a93e2a10fd9e0760f3fe29c3b759f6c"
    sha256 cellar: :any,                 arm64_ventura: "5148dcbce461efb29c93b22c780d97a611a22dd1194845ae69f05387a20df6a4"
    sha256 cellar: :any,                 sonoma:        "90b75da5bcafd8dbe70ca0518c341522a8247e9894dc3f460d06bc8742e59037"
    sha256 cellar: :any,                 ventura:       "6c94c68285da17d5d23e52ca78aa171b8cb736643acef15887d80df3afc8ddd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "211ca28358057f23ca265b763c11658c782a30480dd8fc1bc5f5ad27392dd36c"
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