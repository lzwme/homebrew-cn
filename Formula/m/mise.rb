class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.15.tar.gz"
  sha256 "6b797b998d9e6dfac46c052134d15bc76d531b15b5ae899b1b10c67f1df79807"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b514ce150c1719358b3703a97a13b9b5643aeef0b6dcead7d5ae40ae345ccbc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "415961c9dd3d808dd94e43ec114531d5972b3eb5a4a1dc0ff8a1dc7fab02947b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4164f7ab838b7b9593a543107f8242bae723d76ea232a2197aa46f949e84f803"
    sha256 cellar: :any_skip_relocation, sonoma:        "735fbcf43ddd5b9306ebe5c7da9ec3b0b5e3fc43f827d44feb1838617ea73e65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bbd9c12889aeb6c58344676a7d35e1f3dc80452cd4a381c1cff8d44ebf73b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb98e77f6fe3b32f9fdbbd96b6fe4ea60c22cd1b9208bcc0d8eea46b52746e0"
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