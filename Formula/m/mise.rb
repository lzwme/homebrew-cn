class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.22.tar.gz"
  sha256 "714f462702f58692a89546f0afb615e32e1141b8c9bd5ed2a958955a4feda170"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1eae00f783897a8dfb10218959410fcb442bbc438d30bbc75b625f21d33672f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "098c4f76932e4ce7451a6d7b94577f14af1669bbe0430c2edda3e64ccdfb2aeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "297dd48f964aaa29ca810dd70af524ec2c2fe099b07a369b202d16d5c6b07dba"
    sha256 cellar: :any,                 arm64_linux:       "5a7dc345cf289c7b86628136d3174139c5ffe9c8f935455756bee234b9b55cdf"
    sha256 cellar: :any,                 x86_64_linux:      "53ef5113ecbb8cbfc3edb5c2df41bd6afef245c5ccdb396da41a1ee8cf12e8b4"
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