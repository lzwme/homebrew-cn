class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.10.5.tar.gz"
  sha256 "324c38cc9693a574d2bf53a920321d662efcf7d803e9b783ff779cb384e6e3cf"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ac107d49b3ffa16ce39570a6893e489a06582871048097c6aab3854ed3c8120e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3ae61e2d7aeea45d3477f8defd42dc24504f541e5b9db6921e829f69628d376"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95f40eae35b9a9a68ab3a53bccf9b4dec6e16f459217656f70866f39ccf549b1"
    sha256 cellar: :any,                 arm64_linux:       "4fff5d2bbdb0e059910d8002cde7188afadf78f341748e643a56a9c70eff7df2"
    sha256 cellar: :any,                 x86_64_linux:      "566eaed107a58d6978c74f5683aafc516fbd9c205cf8a1bf2d9f7953f95f5c3a"
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