class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.20.tar.gz"
  sha256 "0473f00208b78e6fe4f6e88a0241a672044383e46e633e8d1270eef3f74a6b02"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d9cf57c000855c1b0946dabf5fc68b73a87ebcff502ac68d175931f90b55a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e8c6900ee9056f895eb7ade75aba3fbf4b832c28e8cab65081b3e0813472c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1786793c1199e0518dee636a8038135b383caf47461c250620b24e41234e2479"
    sha256 cellar: :any_skip_relocation, sonoma:        "92bbf4689677079cb93801aa350e05b9845fbb29bc4dcf6447e3aee00558968d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "767a25d3ff20c2b56a93a66ab695e91bbe5398a885379b14edf173ea4225ef76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48ba6cef5058c1e3bcefb47db6bb2d1eea68c0c53511151e361a4be1a67b5fd6"
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