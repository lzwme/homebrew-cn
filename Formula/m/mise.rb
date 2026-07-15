class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.6.tar.gz"
  sha256 "0c30f3f07970f643cce98a7c8ee4c7761b103cc48fa37044656fc6d1a30d2a4a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c258015db11163811fe5dee7178cc4ecb30b21345163c6658000405170ba58f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3dd7334dfaf6f890bd0758e4fe907f9c6c2003ec0f17d077468eebbcf13e242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47e6723e438817a5a34e240db1c2d6ce264a0b0d98b1ea2fe19c1aa17cfd6c19"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd48457109ad8837f4bb25a8b218a1dbb9b81dbb95ec2e51e45c379521147d44"
    sha256 cellar: :any,                 arm64_linux:   "e9717330434db52812a5b009d2293561dc32404f294f9f0afe32e93cc0eb21d4"
    sha256 cellar: :any,                 x86_64_linux:  "ea40d9ca5a2618f174f42e4da07d0b5fcddb74e2730627f24b963a483ff5d552"
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