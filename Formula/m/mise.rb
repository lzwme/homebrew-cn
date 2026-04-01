class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.18.tar.gz"
  sha256 "0cdd7d141384bcdfbd01571720de62e98db74f94948220ae8040af7767539574"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a2692dcf77281699d4190070313e38916961a3f96a937f0b714e64c472b64dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e795699eebf6b99f84c50d54d9ebb291be50e8894e1f97055f998ab6720c90e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19755b6bcbe661076fc93d47c7654317c3c298a9ab73fe472edcc11cb58b1be4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e81f9295d203177687f3b78beac66ff4272c056a42c8d6e2984d3ea85f711dd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f113600aa8e5b2aecfeb8212ecd9a736571e4883c6c90de658af74166191cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f682a3dda6d89a271d2b723974186670220111167d4d4e4e64c7e3d5018f5bc"
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