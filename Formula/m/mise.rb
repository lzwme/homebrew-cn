class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.13.tar.gz"
  sha256 "1d843cac2fb96f0093160dcbb2822c71647bba6ad316a02b2cc1509682878cd8"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "789c213ecef13d22bd29e32e1bd5fd30381accff0cb1ab178d207975aeb2cb0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e43ad6f774f82e77b3ba312ab86f952b80f252358dddd37062b92ab54255e57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2699c8c9f0b158afde3d9fba053493948c015847315ce9e07e76506cd517684c"
    sha256 cellar: :any,                 arm64_linux:       "d43e62d3eb31d3d9b6d6a2dc143a3eb737618156ff2c903c99967f888240c92d"
    sha256 cellar: :any,                 x86_64_linux:      "00977da406eb70cb88365daab6d31e544d95856a38fd5da69d7667afc1f3c61a"
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