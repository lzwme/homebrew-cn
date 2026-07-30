class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.16.tar.gz"
  sha256 "ba6ea274b741d9db01665e5f3d3e01c0fdb45db7d0f50fe65bcec96074b375dd"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4af60e7f3eb29dfa8102b4d2508f871992adb638d4f506c6534d57c0c2144452"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be211e0886cda235155e8901abe1708ab92cc6ea90c4981df3159ca6bfef5a00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0931a636591453d003ef460c1ce410842e9659bee034f918ed09d353ced4685e"
    sha256 cellar: :any_skip_relocation, sonoma:        "aae5f5b55c6ee76416ee600a5e543c3635293c121abd886cadb5d0fdb4e02663"
    sha256 cellar: :any,                 arm64_linux:   "42914e23e91d428d0c0c5d44eca4478536216e28354fdfa4c46c73abd8062f7e"
    sha256 cellar: :any,                 x86_64_linux:  "03be3bd2e5a79e9b83d479dfb457ce69dba26d7232e6327256f3b4336984e333"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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