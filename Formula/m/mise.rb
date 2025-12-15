class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.12.6.tar.gz"
  sha256 "7ecfd361caa182d9d3da239bf92d0178ff0941ee5c49c28c976df33411c71dc2"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc57ec9befa543bef38bd6919e4e673991e6cfeb5d561db8a50dd467ba5ba697"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f62fca37f84c9d16ba9ec9688ccb2f08c752c84d05a54bce02aec3d2af9d5f04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e549894d5c53220111168e6733cf949c0af03b493c572d7a4775e3a99f64a758"
    sha256 cellar: :any_skip_relocation, sonoma:        "edff1c5416654749b9d22176bfa8bd7344251884bd28baf874d7b692a4d629ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd5fcc354d746f1f1194cd4c909cbe1814c594cff9265b37d0b103d2642d73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "300e91ff9e9b4f7c370d605984e27f2f0b2a71f1a73a1df4a4519bb98b563506"
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