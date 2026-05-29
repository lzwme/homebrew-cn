class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.16.tar.gz"
  sha256 "0267bba073d30f7fe4b166c77a190789188e066627c871bdbb9bc2e867d4ee1e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f63593a607abbb740def789ac3ed3a3bea889292d84cabaccbdc0f70e8ae3b71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95bf8c66362512a5972efbe6e751ebcec2729c5ca4afd3fe39df443007417c04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd66c76481c0cad4b64dabd74962d2e50c1d76a63edbe6adcfd7d8e74afc497b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5761197ba00262e7c459ab115a1382e5df7e0312ebb3ea164dac814ccb661128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db66ae8a3bac273b76489c0920aa2905d975bce0247aa85d31d36b218fbc7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed9b5bc1b10b5659eae0780f1a405bbe7df41f8ce5f1c89b53721b57ca751b1c"
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