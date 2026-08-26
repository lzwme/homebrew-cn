class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.13.tar.gz"
  sha256 "934e5ce1aef28d9e04aef21ec4f3c1275342e76f3d66195b356f541338eed095"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "817d07d696b7ee00a6209b982b4806f55343f0c6f5446de2633fbbc3909edd19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cc76082789bd63156229080828344173e63797c7a0aed10fb9c77ae08c960d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c0a3f8cc0b06796e6c7856332005795015fcc4f2a6ce34c1cda243304f31bf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eb129fc083c907e25df79b3d6ea23e584fb6a88647ff504e900be7e6fd87e18"
    sha256 cellar: :any,                 arm64_linux:   "30cd826e5ce642d54791d38c27eee1fea5e09066772872d7b0bd90a8e37de6ca"
    sha256 cellar: :any,                 x86_64_linux:  "a60d0b5258c4f7c4b126f903775d82dffada2e00bc8d3dc94d9f6fe428dfb1f8"
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