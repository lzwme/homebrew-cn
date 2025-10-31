class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.21.tar.gz"
  sha256 "a4254cec194f3cb456dbdca10356937739863e5db117f7f73b756024ebddfc96"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40d0b3ad5c78bdcd14170514336c598b93160d5d207cc5bc99fafb1464058720"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "692eca06627a45f5b2c3e38c77ff179b16fa43515b0d88d08c43284dc1033567"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "401a3e70b0d90d414ae3a7d7ea74b272e0b327cdf4fa6c72f50f25f7194ef187"
    sha256 cellar: :any_skip_relocation, sonoma:        "5594492a7b8dda70cf001f8221a6ae3f6fa644db638f86caa579bf3c2fb269b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2bbde36163583fc9959932acf9cbf1b5196876402d7d05c25e5a0cff2395c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e7bccfe9ec6856519bf13f89652c850dca80faf87c07f8e4562b407214d5ce7"
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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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