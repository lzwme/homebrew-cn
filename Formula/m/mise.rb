class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.13.tar.gz"
  sha256 "6eaa2fdad3ce35accea2c120c5f8167856ba80a5566c1c44415b541b14b6ac19"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5884baa7c16f5998bbe04a162da68496ed36fb3e0c050302d6e328d3a0891bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7586b49f7a5dda386efd1fb5bdd412d78a18b9d9110e894bc243df7be7ef4804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf6cb4a01316d01ae63797f75e511f51b20475046e83a65a29d54f3e7da92ff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a23a6d50369ec9d6d68ab968e50f485b7379bee4df69c0fc277034d30b677091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eaffcbc3bafff408471b1588e8a2f16756b460a83a98fdf4cd9d305afd82f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "448b150ab3cf4d9f5d901c4aa5629fa10b0239d4f0c5a45280433f96e253b628"
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