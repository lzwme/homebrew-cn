class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.14.tar.gz"
  sha256 "ddb9e19a44a424ffea955fdaafe30d5a0b60970e671d3c6087a11b777366217a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c868ca6183e71fb1c2e888ba85143c5be4730d7318cc4a322d39ed5c963c85a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "716561c659ec3c886608ea6a9eb714c726461992606cf791133d9157961fc96e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d75eb4173029e43aaf09d866113e3ff399a0a74b9489f77022d58014a37297e8"
    sha256 cellar: :any,                 arm64_linux:       "c0729f51a7616847fbbf6d4598a8a0b217036c9e0936da0205bc710140c48f71"
    sha256 cellar: :any,                 x86_64_linux:      "538809d79acf5751152a6dfa737ab22644f913b2c24b507a3c3610b59357844b"
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