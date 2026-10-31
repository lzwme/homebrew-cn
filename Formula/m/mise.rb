class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.24.tar.gz"
  sha256 "92a062ca5ae39a639f7acbe456f001b96882842f288d70e6219af364f4b9d709"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47c3962eea0d47a7c3748438248e8ccbb6b0e43b5f2571e2717e2c62d4b0dc83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f307b2afde4aeb2521a70fd8229a75fb9a13da12fe8dbce2eb48edf2f8d9c3ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2450ab357ae7423af44a64f7a216ce1163472e0efe9fd962b2d1ee4b24b88a46"
    sha256 cellar: :any,                 arm64_linux:       "ecbf1dc59a7dd95bd4bd43ca4b7342f2e7c81f13880a62713a9b6e3155c12f30"
    sha256 cellar: :any,                 x86_64_linux:      "390c4d1163f2c2ae5665587a3f2b1698ed7553a3d8c74fa5f2360ad061cfe0dd"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

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