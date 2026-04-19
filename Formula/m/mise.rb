class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.17.tar.gz"
  sha256 "7a88d9983c6574cb847ac049891575a59fbaaadb41f0a47b917f6d16d2ae3471"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0a0b00fc1a47fa88f37bd7ee62a9c5a96c4a3053de262f6a240b635d7d78a68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ca13edb2bdfb4d98fb355315831face0f69c40bb98c03a15c29c2113b0f7693"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87d09a84cd4c730b5bd0f1d7c399f86b9d7364c2272123f7299a5948da8c3d13"
    sha256 cellar: :any_skip_relocation, sonoma:        "e20f35c4a6b4b25808a49700379dbde9c043fbf092de2fb21b9d34678fd4d46e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ac9644467b582b8abb6b4d273839d522e8a343075388d5213f33af14478c386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a180b9bd50d12321e2dee8311910cfc22a609a30a6b4d8339b0a590566eb11d"
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