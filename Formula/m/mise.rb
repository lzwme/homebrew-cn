class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.28.tar.gz"
  sha256 "06c754c9f929053830a4f79e3af76cab384c33ac53be7a51430a5055d4fa7300"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d87a330847f17e16a94d1a1289d37fe77450bedd9b470b9b25418d28ff7e7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ae54664f6f7942b3b9c4edae2df7ae97e2152c1909134b9d60b35e8c25a696a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bbdd9a644e5a92d71ebd5bf0c641b39eceb9fba1aeea1125f4a132c61e220e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a97f6ae83d84186209aa49f8406f01022d453727972c4c34d819d09402943ef"
    sha256 cellar: :any_skip_relocation, ventura:       "5db65c1331d9078658772d0c6bef4f35463f24195489a41c636d84ea2b0cc927"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ec58fe23d5a0e3fa6f6f22ba264f4fa7719c5d6dab6fbfa7cbab4a46db467ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f620d294aafdbdaeed68483f005386918a8a38c97bc0999b6e3ef016800a4a0f"
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