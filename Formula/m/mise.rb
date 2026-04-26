class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.22.tar.gz"
  sha256 "8263c1423b7746ec36fd657f90fcbfd5ad8b2dd480919d6196b8bfa259dd34d1"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6e6a70024844a9048c64d9c62567b184e947f33725743eb49c64f8eb2ee6829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f312f9692906c060451bfc61132a3760df33057281edaf4f70044be758e5f072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af12c1557f2ea7d13acf7855cebb553a3841ea51c8ecef0870862bfdd65467f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "457f31503d0ff3452ceab1640ef48a568b930f518c43ceac4524e8c8ecbe236f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdaba2f888594e592a7a44bfa34b5d5f912264b6aa821cbfb2780a2f130074bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9c573e910b79d095266bfa37c5f3309a9669df3703c16f3b53834c5210996c"
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