class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.10.tar.gz"
  sha256 "11e26a0ec32d3aef11b9bd04f0037a7a97198bcd2a67b1856fcc6e120956b7e9"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "edabef9e6b2edb6a7ae323deaf5c8fa2d86e6f31e23ae44d538bd59d3b30a899"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f91925857bc60b12daf41829624007a557ee2334b08023214cb5d7d1932f3ed3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89d40c57a5df93c7e50c4f3dba7e0d4fab4c788474e9577909f531c277dbaeb0"
    sha256 cellar: :any,                 arm64_linux:       "ee2e61f68442beca2a81ed97dadb5f14edf6386e5b98418b420f1146f33c774b"
    sha256 cellar: :any,                 x86_64_linux:      "fc2540d14ff1ed1914e3d93d136d579ffe96bbb297deef6361c1eda1afb88277"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

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