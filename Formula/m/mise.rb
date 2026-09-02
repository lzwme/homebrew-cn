class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.0.tar.gz"
  sha256 "eb7f37344e26fa1972b22a6b1deac0158bf84da5b8afcb9ca1d966b8c884cc19"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2afe36fdc943a43130fe976ffa85e27ca95a91474c7f2d961d08bc783ef206eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5f1817fb3b24594553a86675505c83fca95c56177cdc575474b1e7752d06f4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b482081644259ee3328702041b0a7256d4bce1548c16668a9ef3a6d85b35c1ca"
    sha256 cellar: :any,                 arm64_linux:   "8d374eb0139f2f8bea2eb01bea404c7fcafc47d374ed7c8d7f984d9ac32982c4"
    sha256 cellar: :any,                 x86_64_linux:  "f53424dd8b9d8791ca56842340881e10eaadd65b23ebfd3382add36837debddd"
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