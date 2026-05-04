class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.0.tar.gz"
  sha256 "0b5ddd1bd09fcb090bbdeb5e379c00738b813f17fdbc50bedf9e79fe5e52c604"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65f02478ad09a65264c4f0f0543a0f5fb9a786c833852c19a60bf1891bc6fba9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "401037e9bf13145762e3076be2a003a704f7af25f14f1258537b7625e5a7cde4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "503af13cf04d71362148dd94ff17648fb5b7381f80728786117e1a792c5801a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8042a3a1b9cea014fc0ec3359a7b3a89358fde8f56596997bbfa96bc8c1665ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "670ef4ac6681d4cfc9ec5463b943fe74eb3f701238ada13cc46059a19b6c1891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d09fff19dbd783bfbff69b96bf4794b0ebda7493c87ad61fe5c0faf38573bd98"
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