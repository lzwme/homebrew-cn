class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.14.tar.gz"
  sha256 "a83d44c1a69f70f07e5630f76e5fdf73efd6cef6e9f8db7c9749a48efefa2488"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9c24a7d037f870a37187014ec9fa5176395d3504198d9a7ee67ae7c8af5fd6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fde3490e0df612dff51725ee6e8dd9541182ae445099626d5f68dcca5d2aedf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c81bcd2eccd64cd9026f1919727a5413308525a213530ed8e38a540b7179783"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa1cba7a0d4bd555f961355598a9cef8af60eb839a102f8fae46799ddc667ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caacfe648041ea8830fa785da2aff0172f25037b7d75f2f7d4896f3eea64cb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88856c85d96957f87fb45d960e6f4868d0ca8335136d6f09c269d282b4b341a1"
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