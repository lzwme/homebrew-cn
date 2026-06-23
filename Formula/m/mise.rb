class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.6.12.tar.gz"
  sha256 "b0b75e42df13b016a4bc2892c68c6d5928f52b5018bd70593418ee868d6c2f70"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edc9a635ff383304d090476aec631a16d78890c649987a90fbab5c87cbdc0803"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "629635557858bdaa49646d5e51e1ea4e194f7f084bc9c3ef0aa0614165f90d1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b13685ff31433e3e907246ede8c43bb69f05ed577d695a0e3bc936b5c8739fdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "124395372f69c75fc2e5c0129c26d869adae55da3e64d91ea6cf26417de51076"
    sha256 cellar: :any,                 arm64_linux:   "b209a6cce6c0cd8e9acfc36decfbc8f30aa20c021f73517cdb0a841159b66b82"
    sha256 cellar: :any,                 x86_64_linux:  "2a05ff02598d0fe8adeef0ef134f7e89cc390291006f6068b8df093fa9e00fa8"
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