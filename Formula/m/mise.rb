class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.1.tar.gz"
  sha256 "744235ded50ef72598b26a5cea7ca16d9d526be410ccffe19b9011e22fca46a5"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f1e81c774a6da63eae0fc0db2e2f4c867ab73b5beef92b530787dd237f99bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e435954cbb7e019499556c40c3a150bd26f99d076e162705a59008373bb8fb47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d49f20114512037144024e71c4d90b0d9ddcf5a09fcfeaa2335249b3399ddc65"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8f810bcd6324e817cc8b165a80b303abb6becec5862bb4d6bb2c9ef9ca39ccb"
    sha256 cellar: :any_skip_relocation, ventura:       "dc089baf9067c150cf51a53a78120221e6fa2991e885946fc8bd884fde57b30e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3504697357db217c2123444ac7211d64ca0155dacdd2f0d0a11d9885b0b1720f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e08739d09fd558c0e2c75acbcad0c89f5bf07f78316b3411e4097b0c8542f4b"
  end

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