class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.1.tar.gz"
  sha256 "13b3ec71f8c7c1b05227f6f57cb2f80ec5c1fbea2582b2cec5c9c5af079a1317"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "299b39a3b288c7788526f1936aafbd484ee068ce34257808d5197117017c5fea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f3e29639fb5c1c0b62347ce336bc8fa700b782fbbe011c81f8b706d207e636e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a33be50d9f1197bda00ffd27245e89b0e8541a2ab264ac3b44934e6f5775fef8"
    sha256 cellar: :any_skip_relocation, sonoma:        "294cb8ff5081b346cc0779f821bed8d571d2e2159adfddaca2f9a12f3611d37b"
    sha256 cellar: :any,                 arm64_linux:   "6fe27b4891ed64a627a1b56a498decdffab8c61c2c82c1a4b3dbf73bdf26d6fa"
    sha256 cellar: :any,                 x86_64_linux:  "2f4adad89130419bbbfba89742a383f546128dccafb237a5cf0475368c2fbe3f"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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