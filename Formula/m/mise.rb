class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.10.tar.gz"
  sha256 "86530bcf50f46377f1c954b4e919390e765cb2642c402bd847ba472fe42e856c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b3546b7843547b00409ea253013e78e713a120036885530b32ca570b17c30e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e19b581e6349f702cdf1307ec7e31fa2153c209c6c6e155fa634eb66f0259a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac968cacf88ea7a3b4813ab30c4d1fbbd5fc241233171db034da075a7b843958"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5f40c7b77f196f476d834b7e8a48cb384fdf923f47a105262998a80f26be3f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b472b79de00f9e46d2c962adc3c9708444bb65c5b59b0aee53ab48a9f2632ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6c0254e67e4f9b5265d2c405be13154ee9bb1f631b33ed6f7b3b43f04629b3"
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