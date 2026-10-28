class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.21.tar.gz"
  sha256 "bf1a8c83da4e5bc51ca1621fe1f5cadc86be9bee81a2b660f6f73ac49552dd39"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b279069837711273f4a2f2d83b8ae5fe457b9edd3b30d2936edf437a8c48a62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43580d531eda96e94d05a55eeaf1582a670ff398b5dc6fae630cdbb6f4d763a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b3dfe40531daea09004e12899c40949e668174cd4f590dbb45aa7f0dc8e68488"
    sha256 cellar: :any,                 arm64_linux:       "8f3edffbb21cbbdc0d628f45a598c9b6add505778ee6e299d73acaa781fd03ef"
    sha256 cellar: :any,                 x86_64_linux:      "56728a8248592a8b12ed27e010d2ea0140bbc12029c14c3019c24ab43d5fe7e1"
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