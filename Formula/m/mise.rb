class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.7.tar.gz"
  sha256 "9df4ef693b97add732b433b01d143434b6701f7f21425e9c787cb685de41780c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b2d27fedf63724c50ce031b3d28c1d9f5ff316d09ffb0f4e5bb79fc8ae3a27f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57a253d2a9a1979707493d1b19436823182539ee0045250ee1b73f3d5b1f7d25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5d14568ca88aca9e17a7f87fea58ab4316acc41fcce09bea7ba7f70f572b3af"
    sha256 cellar: :any_skip_relocation, sonoma:        "f009216218881a42815d95d0b0c6eb122aa8feb7e221cc7a113315acd089513f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e56b4141e4b25ed57ca15cc8526f2f2d62a2dfbc24759a403f4eb75f92bb7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e01f38d9763e2e4cd38217f3b5e72dd38d28fc6360fb6906e88263728794907"
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