class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.0.tar.gz"
  sha256 "e171d6f00a6241fce51478d0dbbc4effd968419728e6ce08a331c44bb121cedd"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d2fede35b4dda2dcf8762dfc11978d687359d21c248cf0b53ae6a4b33a37f1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3af8d09a162871a7de0e1122336932b979caebebc4eaf46f74b66ce133403c52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27ffaa1665b6acfb755bcc711588cdc65e10dd8ef03d5aef470c7393e5de34dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "497abcf23b9a652977bc23d7758c01c83e813d93327840411851d1d40c714a43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1553ca21aaaec1ae335242d0e698cdd61265d604eef3c4e1169d236612c476ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5af5c4a967dc5f5fd21fba797b09e509f11288a574842817b6d8e0ab586735b"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end