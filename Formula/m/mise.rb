class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.15.tar.gz"
  sha256 "f42a28df32572965bb8cca94ec6566aa88c4bd3a79848aeefd54de9296cbe44f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2212e1fc1f636d0ad10b08ab005c9e482506cae09a308eb1752619e57870be22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be8642fc03aea13c85e01a86f6f55a755ac8666a50cd02b257cdaf31ae231bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09b8f2f4281b508b4a0f781a24627671587d0f2709fab7094a8d383c8937ef51"
    sha256 cellar: :any_skip_relocation, sonoma:        "33c1ae3bb7d1efe53a9a39607282987b999cc926638cf3cca6103f6b75b8da84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69af334d2c06e629c33f6a82402b1150a349a98d58a09949b64ea1543a25d2b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "043e0b21a929119ce5299ac1393e2a9b03da8a72851ea0193c07dbad23246eff"
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