class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.11.tar.gz"
  sha256 "5aaecc28fe6335c0f99ffb32f364530d618c95a76cc93c63ab4476de09c2f663"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "684166c6ce593afad4c2629e9988b8bfaa51cb0a3dee260aea5cacc65001233c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a1aa4f16f143b43f63236f1be6db440c92aaf9a937cf26b4213f8f2768dbeef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a70b61f0e6e34e2335cc97715c0ea863bc77956860738a7498adc6254d936160"
    sha256 cellar: :any_skip_relocation, sonoma:        "9659d62e645435d385f68685e89bab6adb1399487fbfa2736b5bee8157dac035"
    sha256 cellar: :any,                 arm64_linux:   "e0136f3f6af5301363b8bbb7ecd2b130b0188d3ffdf44486ffaa48526b29dce1"
    sha256 cellar: :any,                 x86_64_linux:  "7f412273ea7b8a90a41cc48c59e395614a4ed06aec3a3ae9de5a6d7c95f2faed"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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