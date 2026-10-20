class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.15.tar.gz"
  sha256 "06541cb2c26cc5a75b5586fdb2121fed10b6da0f5559f406cb93067847891a74"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b9477eb464dac2af6838fdd765ffb769d9f27e133e3d0825f6e641e63578e77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7fec14e950a9a82984b43c6413db44b3d3689dd446f2161e3b09d44488ce3882"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6d2ec2e885d86e45ec090ea171a5ca5fbd4f6a0f74ef95aba51146696ab6351"
    sha256 cellar: :any,                 arm64_linux:       "b7ba02ac57b16893f3eca0f2a211e45131215857a456f4909b0b00c7a4d866a5"
    sha256 cellar: :any,                 x86_64_linux:      "18d42f901b9d03889271dc1266c6569092317d3300e4ff8c88d0e9495140f6cc"
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