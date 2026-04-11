class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.8.tar.gz"
  sha256 "1952669635b088601261f4afe58ad130965a67db2bd657d8ee9d2bbb6eaed5e1"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b86d28bde67813f15935001c67d8798466688c92b39b66e4ae21c421ffa2fc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cadec94c3068c3d538cea86f13683e742018f2174f580fe5425be653558c5951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae36748c796eccf006441586a5fdb5282ab0140bc743bdcbc3d44c66ae891db5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9392844c1b153bd77eaa60090d50ba6bd5c1136878bd199e7e80b35b2f261d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b9b59eb3533727cb26752b7ef35f795447baf5b9ab94e7e7dbe8f311354547a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72aa84ef6b5b31425904b74c7d6ae82a7e522902acd157064feffbc32b6f4795"
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