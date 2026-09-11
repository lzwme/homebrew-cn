class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.9.5.tar.gz"
  sha256 "c7685fb918c10cc8e2e2b4bccd004446b2f0bacf730235261be3d8c0dfe7d728"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "24954218ee3c782d841f9a19a7c0c4fe1d265b423c9fee286a60abad5c7fc5d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10094f45663e7ab1b76938777f23fc72ab8870eebf5083a5a4ecd3f05f3f4a78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08e7190866e70fec75571cb955dea29b9f3d630fc3e95c695e77c91ea0a64606"
    sha256 cellar: :any,                 arm64_linux:       "1294c0698a89db45b0fd7f7b461bdc1c713e1e87a9c6b29e3882d0f2a66bd7d3"
    sha256 cellar: :any,                 x86_64_linux:      "26b1d6dafbd589463d8df2d061762a0bc0ee9f2dc1a0de37f4bc97c4f17f808a"
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