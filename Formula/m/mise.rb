class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.1.tar.gz"
  sha256 "9b3f5b4134d0ae334ba50f2424e839f72540feb6b9e7fedef7dac953b034ebcf"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e0c439108b77a85a98a7cb159d873614ad7049d9140db4044acd5a7763c75ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdcdda817e7e03e9235233161aebf97a8285ee975913801e25d48965d5fc2e2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "742520ea9b4d203794652e1bf48105a8359ec7ac80c4e53ed56f54b4ef0d08ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d3acb72c23f66a42655120680402c4ea2dfdd26a1384219cf140a22d3803bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db2fe82b1df395bcee92132bae5a31f0cb74a02f4c4f3d2538489defc7c49dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e2b59c6d4dd4c6d66762bec0d65db24815c39d7fed036bfd5c78cf879e4e81e"
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