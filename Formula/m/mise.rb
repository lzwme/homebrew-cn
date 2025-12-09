class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.12.1.tar.gz"
  sha256 "24f6cb2f2aebc6b1be8a4fc25a0e2764b7c20073830fe25667bd2a3a649a659a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53a8244ed471a5a7ecd4b41c15681f362b0c5c34966470dd0e34b1fa6a2e4637"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87c094fe4d68aca70c0e749174dbb012cb05946ca7d2e931cb0e32f8672a6d8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95589e30a0010745bb9cbfefbce48a50f4d7b0f69de0764a171255302f1d0bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "14db6f5ef28b5e2693cdffab28aa4b9df8c8e2dbee052cd6a0dfa333913cf9e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f21c684419c96325ce198aafa0706a2c16d2124ff5a3bfc921e02c6ac76931a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "561256832ab040982e1bc573a3f49fd2b3592129ad0ce2ab63a000e0878d9c9c"
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