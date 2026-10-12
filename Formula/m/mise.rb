class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.8.tar.gz"
  sha256 "f1d5e30852f973a435a78859058c698d1f6d8f9a6da8c5a0d933ac6415a293f8"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d6aef20f62eb1b124d65ed2ffe2cc4f6f447933949585a9dedbd99018675953"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "957b307ee68b8f267bf5a7ad40f579c71fcfcd4e58ecc7c1a5d3b4956f3e84ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "272343a43f708ebb44fb73c12f334dece8f56f81fe64ecea390eb4ee7dde897a"
    sha256 cellar: :any,                 arm64_linux:       "27d741147199d58bc982762d0dc42a27945537d15129f65c86e3f39e527662f5"
    sha256 cellar: :any,                 x86_64_linux:      "91b7ab3de994a7c8999f3291d9c369d6d579bff171fb37e5cd1bf3b41ebdfde2"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

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