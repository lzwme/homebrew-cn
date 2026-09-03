class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.1.tar.gz"
  sha256 "a438ab1357196c996f6f2c15682ab4143ff4e474c05c6d731923b52d5fc25d73"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "877b0cd78b89ff73e1a07eb92cae0ff7682bce96a39af1bd2a5603f42a87faed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27bcbf283bf225934cdee99ed5bf592d7aca5b87cc79ce99e26011b11af7cd96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba352c94a8627b18283581a099c4b9092078cc5671599ac3b9e06639330156cb"
    sha256 cellar: :any,                 arm64_linux:   "d9f74f49a9c564d8ba1f59acaeb05d54d07f91b67669350e7c15f461b3de4fe5"
    sha256 cellar: :any,                 x86_64_linux:  "183329b850bd5ebbe20aca35e35cb8cedea40228fc46ed16a5a7681fa4c2179a"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

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