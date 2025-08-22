class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.16.tar.gz"
  sha256 "60bc9c9dc230f1a25505939d06c46c946e12c8c48db4ae8405b87e7a2e430c27"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9097fc04a39340464db2880b883b777b4df41047ccc1bfdb8f9665c9b8854d89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74f83823cd28435e82f871961ac28eeb2a7f56871f768280adcb8497262f33eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f3d1a3cbd148f280442f23108cdec0e145cb3ab540e6fb93d0d40977e1abe86"
    sha256 cellar: :any_skip_relocation, sonoma:        "1470d1ee2951a5a14599d21b512c5b55b343dfd76ee6a6433666bab2f5609ac0"
    sha256 cellar: :any_skip_relocation, ventura:       "ed9a4b971a925f9ff2b6e7aa490cf31e41e80d7fd20bcb4abaf782d38e56e815"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05c9d309ee032a5bb5fbfb60d302ee4705bcdb8944eae3e48a2c885d1cefaa41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a59bfca2aaaecc8c2421cb45a409dd4090994c77106ac8e53c2b1da6cda73e2e"
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