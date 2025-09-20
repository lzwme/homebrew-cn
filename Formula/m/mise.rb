class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.13.tar.gz"
  sha256 "e90a0e25c389cb8c772e6e223cb54b5a107016d12e5bbaf2ff3a9174c15f41e0"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01671d610dfa5419ae4db48f801b28b6cb8a38db96f3c811441c2aa20f70a502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6fca8213f2bf5b3201f9aff0b6df03466178e44ff698546142746d456023613"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d65fe3c1bd8244b8245a775cb105e48d5509c8f26b7206bf1fec31a275ed50d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b466fb04bb955e712d6815b24b14f1061d49aa05090ab83d026f99f39d01c8f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3bef8fc985bc0f346017f57d341b7a9d5812d17a1b0cf11224da6b555320403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8e55a94a9131af0f0dc3bdd9703d7d0e57c4ac3e1ac1b7a5e6445890960f4e9"
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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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