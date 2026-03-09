class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.3.5.tar.gz"
  sha256 "30cc54cf6add8ac3b07726c763ec4d581171bb0ec55054ee1bae363ae7796cea"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a7591d0128e1db04ab56b096c540970cc659f2d97cd6d8143d624b079ad32bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2c135925d71ff470f0faeeb4cb67033ad6e6c2c69e405712be730424a8bfb1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0616b39484da36c4417d79491c134b46ccdd8fc88f2ed38ba4a5e2035e06090f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a06d50cf07f1eda6982a3183d58109ae5e4dd2c04b610a7f06248f3517afebd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15e6cd614b6c384d3f7b059cd39f81cc9cce9b1470d424605b9c178fb5063aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb33ebd21f49896c2d400313295a2431b37fd24c84d887951b237fcc52ff3c71"
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