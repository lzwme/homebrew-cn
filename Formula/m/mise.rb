class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.1.6.tar.gz"
  sha256 "e6f47591e3bf3d5b8763aeb47df52687cc3308fbfb0f32d25b691efc31b3249c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da7393dad61d0dd6694330638ca604a9f9186feef2183e569c7263a7abdebe36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2f3d80313ae73fbee4f6992c23f0b51ade70636cf6d95695527e6fb67ada2bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0105cf4d87cb0cacbaba792e4599de3c831c027977b4aeaf1fa645351b2be784"
    sha256 cellar: :any_skip_relocation, sonoma:        "560165883bb061ff39d210614a098ce830b2698ddcb032fe77a2bc95fc0509c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "533a3f4af74884d8e065851a31bbaee5021570ad872bfca532af4d205882b747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "276e4e42d2647aea0339c165a9118b74a363a2c3800e4072d9681ef365648728"
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