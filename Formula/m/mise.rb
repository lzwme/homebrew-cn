class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.14.tar.gz"
  sha256 "c2b7d1ff258b57b33a33c155d25a610ac025636b8bbe3ea44666400682efbf59"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "142a73bc84942b3b276dc51b60f1f1c1d349a74a664d3ebc1fae12b4d6f6d325"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63c41092011d1cf680f4ccc7bb9aaa549a4ae7b1ab9e201668cb88c8a3bf07ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9a3f94f338cf5512a41b3c3ecb87516378fe8e447671be3907514eb478d68d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "053b0fddc18799df8088d181a4af99a6c5c24bf714fd35de6f77b23cb4fdbcc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d874e85dbbbd07cc7eac61007999cdded97765f449ff02d238288b3bde0968c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b251aef8356864e940e565249e92efda0b2d91065a5420508bc9f1b95d84ccca"
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