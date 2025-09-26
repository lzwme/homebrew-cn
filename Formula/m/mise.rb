class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.19.tar.gz"
  sha256 "08e235f081feeb2ccdeebff45edee93f85a1eaad0333410c37d0016463215eaf"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "610a8237a7fa3af0015103f871e1f8e26f397610e22ab4ab57b64915291a2f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6dbbeaff28f0d7691bac7590cc5007ac5e47bd59ed5a10234b6947b0dc9a382"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "684ebb285207ef7b182ca3f70cb8baf411bc958ed85bed465a0b40e4d3ff7e06"
    sha256 cellar: :any_skip_relocation, sonoma:        "e67846e3a8070a41129dbd1615ec5828c88c77484c61bf154467c2bdcb4d0bba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0456f776457887dc4b3b637bc7552b90b4a2fef067224177dbc3e6763d39f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4abecb57d447d942a8e6723e400eafae2b40e65c77435d7376b1f8a84fd691ba"
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