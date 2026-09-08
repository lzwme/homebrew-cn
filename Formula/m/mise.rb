class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.2.tar.gz"
  sha256 "c9f730e2110211a20c9682444ad4dd0117ce3352662db98674808393f960b186"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12e8485e15b3403eb44c4aaf5ce990ca36f3a79ba157c92271dc086891613029"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "addc3649211a7e0c6929b07bbc0d8967d3917ba57b14fca6a3e1d7a2f024db60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79ac33d12887b9749d1bf41b9bd77209cbbf6f45695b6c5f142e54d871fb41ac"
    sha256 cellar: :any,                 arm64_linux:   "a74580cc15c4987a0b2bdb76a1c9613800ec4a86a4fe3498b6785d662d403555"
    sha256 cellar: :any,                 x86_64_linux:  "ab6b5376aa2a4e1a34e1229fe5ada0300359a10bc08f7b2690a1d2b1fe23f66f"
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