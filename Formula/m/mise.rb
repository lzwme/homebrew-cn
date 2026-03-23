class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.12.tar.gz"
  sha256 "dc23406d8a36547a79714ec9f3db65d402b97b40ce6079dad248a7a0bd0bb3c4"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4c2d5227cba5c1fb832d671ce0b4d9a6abb9cf9d398b95d86377bc56afc99f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02b1d3bc449c30ef3ca0b2e607ec03f44b54a806f5201f2be3a24b82b9d258e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb901057e4e2a6764d4e652e7087240e6e980d365f430919e4fa220db2f2b22"
    sha256 cellar: :any_skip_relocation, sonoma:        "31e356c50020ec75fb5daa5df517282e5a4dde182bd836163cefc2e05fa9fd90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cce75d1c8000f8868deea81343b01e25d346606076ea51004cce619fe4496051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ec963675ae4bcef2b2c6141df25d439ae12a39461026d2bf6d5584a596ab18"
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