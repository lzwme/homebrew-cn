class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.16.tar.gz"
  sha256 "33fe390b440afaaa77a5dd71b069eb2d1e6eb639d4c4ea141458234b96034655"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e7b1cdac726870a473d675edb9f4b00dc87ceee00a6e2a1e394396a79eeca46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c638bfc47fd18ddf63648aa4cd81785f5d24e02a97268f9048478dd66422ae3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea27e1e349010999fe7afc87d01c9505668f7c9e8988f107a044c22b4b061d6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c9c936785beb0f5239b79fe2260d63da1611a5b2985556478c77caa36488425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "336c2c312fe5780540a3fa45f262a11be1e9b1e73a44218ce96fd8797aa268c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ada4c32161a9f11e2073c808cd9f81f9e91e5c4efe920bf76358cd8d1f8900a"
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