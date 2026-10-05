class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.2.tar.gz"
  sha256 "2557e70176de922943a7fcc2f28ec3f31826b41981eef7e8e35bc6abe1c895ae"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "459ac375f612c998ef76af2ededef11c2e9a9e7dd937354a39e00b84010de32d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "299ee7612cfdf68f0eef5dffa045973cd6e5804a3cb0df3309c2a42ed994d5cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29922a4723ec38843f4094f923f088d115ddf6cb844c292c3fb75b1c3554d9cf"
    sha256 cellar: :any,                 arm64_linux:       "ce66b0fd6ff9b6fce8884b7a3519980df17c52ca6ded4f281b9aec95d7d88718"
    sha256 cellar: :any,                 x86_64_linux:      "b1b35bdfcb81297ea67590fd615281e38bf7789c902edb508892e8ad59c205cf"
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