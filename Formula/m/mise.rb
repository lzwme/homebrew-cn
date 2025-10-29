class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.19.tar.gz"
  sha256 "b93523009f2022a4e67f3f9b894f22f8d8154c85dc5c3cfd28ae1d57fa66d712"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28a09fb19fa34f64e389a679df405c40057c243595a3e72f99653882a673770d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba286e417c27cf47089208cbc316764e7117920e48df59a0cda6d6e588e552e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8db73bb1ebf48b4670701c7b89de711d6a6ff002d7b6428dfe79509a8feea4bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "73f2bfee3a013aabe3505dac59e006ec2d90fdcf7027c7ee1f3c772936a079e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "097c23e9beb99507284095cc3c61e5d3863ad09a4defaa195beb808710ecfa96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87e10a3ae38f550a84652b91a6ce00e9f4d659d72b6b16192c641fb1ac0b361"
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