class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.4.tar.gz"
  sha256 "0369019f7c934116863bcb185c3e1c8aca1ebc0a7bb500bff8e208c8721ce84c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1cbddee4790afb184a9e5fc7a51d090ed960fe1c596b01f33173c38be31f1a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d5545e9a6d20d5ec9c8990fcffe04be114c3192d29c669c64a128e71352d9a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51da59ea59addd1a663ca6320066eb9f7b7b6dc0540019d217e10bc0ff75208a"
    sha256 cellar: :any_skip_relocation, sonoma:        "644c9a7b44fe91e7958c63f4a9f1a6d89af2b09c730becabed2ffa1ae6dc1c3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a75ca2d9c8c74eb5396639e0c978bb48038cebcbd7e7ca26b3b915b484092edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1679f311ce171f223770103da2a1782857715fe5aa9af100888190232eb3ffee"
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