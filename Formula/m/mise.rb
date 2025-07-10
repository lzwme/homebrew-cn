class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.2.tar.gz"
  sha256 "ab5d88c9aee6e2c178fcd8997b7eba080d3f653a9690761c12ba215322f1c17b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "529ada41b3f59a9bceeb630a19078b0f5b53e39ea4e4357ab56c7d5b414860b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fe61ab14b9c682fe451e02a16a3005feaef7eb728d64bb24314548435e34916"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2ff54d18c03b5e2e39f398421d14b5ed59e2993bd5141e95f9757c060cd6b23"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef585a8ef975fc25fd87fa8da8f27a25987ace706c14c28e7716a7acc59ae94c"
    sha256 cellar: :any_skip_relocation, ventura:       "560d8b75b792c3a3fbec63510b6f430304b77d65a42ecc877acf968d3423f7b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e4e4428440f715fa50a51850406f431acbe25c340d11f6b2af8f2390b5a0423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4fec15573fcb8e96b9a7340f1ce20cdeee7817a46832994102eb4c4ba58527f"
  end

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