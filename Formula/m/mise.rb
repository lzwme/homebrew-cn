class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.10.tar.gz"
  sha256 "7197628580b6710c38dfced9e093d3f14c7b1f7e4bf256c73acbb9d7823e6ef5"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87fa1c21cfb29466d2c52f9e58893e5046fab352fdd173e345954af0059f3a04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9351501c357631d40f7a31edc20173fce5dfd0e952c704086e68cd24aa2277e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b53d7ae53f236776a1445811cee9f07875426b1d3dbb6aeade468934311a73d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8159886fb0f6c036e392aecf851b2bfd93d2539e5c58bf9e74ab5bdc4d7419a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c87375bb43d5e7dfc497622333f6ba7773a7ce09bccf234605d52fa390d8ebd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "997338816d7c16f832111bfac45467f2abf62f5f916a7f17c5c2d5de6e76f5d6"
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