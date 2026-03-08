class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.4.tar.gz"
  sha256 "7ec15b68e0de9e4286abd4213562c7ba82584c6b75c77227bf70ef420bd94c75"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a556e74f20eb5083e579d9e97b65bac4ffc3fb093789cd484dfb6be25343c6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "189e7884bafc09cc52512463e3c64eded62d50dbccc595dc25863ef742d4ec11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21c759799c4d385bdda92f4bb2f133dbcc808d5a7c1e2e29e8228748d3de4315"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0db2396e68357c3cc1670b5b43d427abf82477cb948ed18c5aed33e9b7e51f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de222deb3622898872800f960e28341af8ee5a40b38b7f356aa1106fc651ce36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d848e149179cc2de2177e40941d893e94ca3bdd33f1ff1ebfb7c199a762a093"
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