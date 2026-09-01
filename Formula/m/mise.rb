class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.16.tar.gz"
  sha256 "8c8bffdcf5865f0e3a0a03e1a04cc37e37e39e76e0cf07ad65b4128097c50afd"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca1660922cdcc28bc67ecb505af51e034c1fe8abf60c620e9ea1d599a9382796"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec10a58b899d5c2605fc3e76e956a1280e80d6923b840e486a1726a8bf0702bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af7c1e330cf3e530dc06b9e625222bf75ad1c9ae35b218f219b7e3c7c89f6add"
    sha256 cellar: :any,                 arm64_linux:   "c3ee3387fbc0a9b78c50e127a570a5a58bde64175ebf8c70444c4f4126df77b9"
    sha256 cellar: :any,                 x86_64_linux:  "65d6ee7200e989571a9eb93083b1e7d55bca0d5f78f8ab389dca9a33589d67f3"
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