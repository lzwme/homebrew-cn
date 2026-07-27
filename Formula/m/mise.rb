class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.14.tar.gz"
  sha256 "75fd7c1b43c2d2af5b8cf3716aaf809f92f20919ee65f7febef1e0659e1ccf74"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1891e6b8797a276e9f56cb0958bc763ba9416d4d3d0773ae47c13f809c869dfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f93a72f1cf2dffba174dcf6e1b70471af7cd7daadf1d4f55e35996cdda784e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "041500ff3aed01beb7df42445797f0a99307b99dc359693e81588bc333b13b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1f2decaaeeb763398e3bc9ee1a1de8f7aaaf98b03f75740a0db33009672581b"
    sha256 cellar: :any,                 arm64_linux:   "ef87b030d9613c96b86778df6cef165542c8b7fc66f403d9a44daf7b9f3b000a"
    sha256 cellar: :any,                 x86_64_linux:  "6bdf79a3520b132bcec139cbb716ae26b3b10ee8bb5b08d9984391d92ce5afcc"
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