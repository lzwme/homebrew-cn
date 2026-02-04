class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.2.tar.gz"
  sha256 "963893419193d9b5562fac3838569601b515230a7c9bc5f74928cb0e18fb6382"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1f5cbea0a7d4182fc6218e152da64e34d8dbd561e9b206705545fc509e53ad0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "608962f085cc6a347f769b14e10abfd6f47d7c7826409c034fc24b89e43210a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81b129dd103832d527f423194f0407a85c059f75f2a0027341c1d921254f9637"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea0136baaeca2c868794a304b6e766677e85aa24173cb73f473988d43ec42817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d31a9a67bd33c57e4bea88f00ce2c04c54a48973df05077b5531f7fc35c58e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d29e477d1a6b7e232c401e70fde0c1d9ed5e9810947198e4edf19a0dc6f1f6a"
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