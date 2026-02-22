class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.18.tar.gz"
  sha256 "1d7dd896d0590e04ef78d1f4da75c3b588fc8729a16b32d4bca00f919c73ec01"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97b5215eb2d1ae5074f0102a1ce2d0880deb19947c470d832e0bf5283b6fa706"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e845e8bac5bc972f6fb039deec8fe353fadf9a63c4f97f77174522bc8c58f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01e77c6a11db2972afa769a1cf87b139cbf069990f91686c664d9129db9162e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "56c730ae98e14861b28f46f4faba7bddabc6f9bec7b2337c4bf7fe10388d5433"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e80a50b52ee8cb4538f41f413e99d92e07f6bbca2820d7de43232aa6ded53a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b409d4893622ad850c36332ed222b1103fe23dce88cc98580d54d920ad1fd23d"
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