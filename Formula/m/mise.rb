class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.18.tar.gz"
  sha256 "ed715186dedb364804e8037faba0918b8ce4789ac38edb050f3a1028f548ab76"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a6c0ca962508422a371569cce921fec0cd3fc1a0e5b79aafff0ea9550d83959"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0db600101bae0eed62a9d5ff1cfb3a28796bdb45d7bfd7a18e55565cb5c0eea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cc7f6fc34dfd4fa9239a6d485e3fc94f99f5949adcb98315bc23460d7765d6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b98c459eb329d1850f428276d22d4832fae979cc177f72dba70f204373d5e3b"
    sha256 cellar: :any,                 arm64_linux:   "7ea014ca996864b8faa698526cd05fe0c978aa32f082ebf85084561c5c0bfb90"
    sha256 cellar: :any,                 x86_64_linux:  "4c0b7b059e647172ec50fc1ddf9ab616c2072b23a41cca3545166030236aaf6a"
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