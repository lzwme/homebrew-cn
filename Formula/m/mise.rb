class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.7.tar.gz"
  sha256 "8e611daa88124b6cc6d25ff76be3e272552ad4a07d57744f6c30ccdb97c66db9"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de7e19f482988a0342c0e2ede7926e670b72e6696a130d20cc676c170469c03f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5a0d4dbf411bfbeae7b0d3329368f891c16bc9c508b67838f8c3b839aa063a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "450970ab7fe02afe0e15f33a7b3216c8f9755c09f8dd6a2990fc5a36b786d974"
    sha256 cellar: :any_skip_relocation, sonoma:        "00be15f5803298181d9bdc48b5cbcb96c7810541b24887c06cd90a543356c111"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee89c536e3b991c881634a57f5f6b64a6759c53f477d19c9ca5fe00d47b5cdc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992c48613e7b9da0adc3b3bd609e673403d56a3574c50f56189005f9367f04b9"
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