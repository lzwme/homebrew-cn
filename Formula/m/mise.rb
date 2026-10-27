class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.20.tar.gz"
  sha256 "dc9c992b21fe02aecb103a56cb51ff2854951f5fc8566d15588b9afeb3c844f6"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e5d82b1bb0dd1b7c9a4f422b5a31823d0666e0d9f97b74eec8694551814bb02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91759d7888c64a992bad8a61ca0d9e210a5a653cc1fb8387051fe35b8a960676"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97befe00ab4ab8f4768d8eacba1697c767187c9ef781d11538b5516f69559bd2"
    sha256 cellar: :any,                 arm64_linux:       "f19c9bb5a762c57f34da8ff844299558941611310411c5f5f3b9493538bfdb6b"
    sha256 cellar: :any,                 x86_64_linux:      "1c9b688cfdbc8865d626a21bc5094eb7ebce04534183b6538a179c824317c833"
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