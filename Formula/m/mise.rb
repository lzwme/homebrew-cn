class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.20.tar.gz"
  sha256 "efe809c07a10110fcb369453ae1fb4dc7a6a716bec251fe3e3b3086c1f1e4886"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dca9badf9ab037bad7a9b2032650efa5ff2566726772d62cba1a9d8c38bee18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37a67f90e4f2e27ee2c91dc0cbdbd852dafc273fd4c451ba116577aff07cc8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38066890e2d1d56489065752a7c2e6550ca4e88d4117fd0f150e08ed286b447"
    sha256 cellar: :any_skip_relocation, sonoma:        "306c9d3049c2ff9e7dc0f01b24678845aae1731fd4c87bf366c6b252e81d2d2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6144993e517d12f346b50ff0b41f340398f3d4c26e8c4b82ebb450e11cb7087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70854a038d90661cbc0f61de4b9c55cf515adbc3ebe169719aadb83a65a1952a"
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