class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.17.tar.gz"
  sha256 "5b72cb4d8eff9a6b8e56b18ecbf8c3cdd220e1bb6dcad6c7b552f09448c30077"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16889820c73d3ff5214156399d0745d9d01a1900e957b3df86a78d74797ff3aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aab1008517481537766310efaa89fa07ae9071aa6e4da77c8b75dabf6b4f947f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54b8f6eef3f9ff35065b0b5f2ec43182aca19eb5e658aea4d2865a80d85f428e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac81bb5ac965e40ab2495af5711e6315564719f921a5e77108e57a5383db6801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "386f6a0611c9f940c1fa703ba9bd935a585b58e525e6d921e686badda0024520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd79635dfc4fb178ba5854bb9b1a50cd092dd0e7bd2c3d1ac995042a52d935b"
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