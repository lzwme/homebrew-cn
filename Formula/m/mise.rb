class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.15.tar.gz"
  sha256 "c39f9b26fb55ae9b3683b7a8133d9244045238d6e77d42bc926c0ac7ef6f4cb0"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58ed4e3367aee6c85a3be47d7d865c284cf91080af5a1e7a028a613509d371e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b22dc49c42899b1034dabc6a2fe400094a12f20fa6e62256283d7f46e282dcc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2f1404be40046b5ee16b7aeff3889f29d0aa89491e199ce64c9caf41d86df88"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5634fcd2a8a024d74df335b79101e0a04712b22c53951620dbf49b907f974ea"
    sha256 cellar: :any,                 arm64_linux:   "3d8c8102f92d6daa29aa89994ff24e4a222d7012cafd99deec4d759ae6042b25"
    sha256 cellar: :any,                 x86_64_linux:  "6942f0a5afe819309ce6ed1f88a3d6e9e8bc8ccb4701c1e81d1da034b06141c0"
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