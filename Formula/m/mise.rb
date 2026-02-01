class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.1.12.tar.gz"
  sha256 "d6207ecda9f9a78d17233699562f86afb66787aba2784ce3b745bcefb661b6f0"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50ed8ee0d2c356cd2cbfab321e18d5dc59164082c8a410f8ab167529a918540e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e46070f620b6e497fcbe1e21b9ee82952030be02ee0ba7e448923c46492d6be7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54a2715b42053def832e5f750bd61cdcb48aef29c8b28ce37992055b06ed5718"
    sha256 cellar: :any_skip_relocation, sonoma:        "11aa80c146d030381d11992889827fb7f64f0f9cea97db42d09b0d3f16973e75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9c3a67de4dc0d57a6793713940f684b234cc18771e86000ea35215dd5f7ef23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d49ecaa5c0ba8ab907e7b1e1997a7604a8dfb2e3690cfed2090c7c8b8c0a3bbd"
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