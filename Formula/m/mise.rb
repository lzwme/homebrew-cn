class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.4.tar.gz"
  sha256 "9752ea74672652903dc20a4327e031da3db389324397e04e1f8d2d10368e98c9"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca67e2a781b3ad4596ed90edaeab842950b8de98b69356485c015d915ec81602"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "96f9600ee56360ae23efd398dec57ff6a589811c762e7028853f2052792ffaf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f1f01c4ad20b0dd82b79103bd494e9939ea999595223cf4f0bd34ee53f3326a"
    sha256 cellar: :any,                 arm64_linux:       "d6208ba4f80f9dc3d9b65ce49bf77a35cc2515a50ff4eea402ba232dd4c60efa"
    sha256 cellar: :any,                 x86_64_linux:      "b938178ea0dd066c4529febf0f5bef0f1b59b2664010f50179ca637e3bb3c413"
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