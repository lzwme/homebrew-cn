class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.5.tar.gz"
  sha256 "9ab113eeba35bef1167e93fbc7b0456f59d5df4ffd8cc8be1b7edc7fc944c0c2"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52801af335598bdd2b13e41b32763dc3cb692c2362bfed15ff7fec4b7bb298b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee3bc997e777af3eebe1f317df2dba13264393b975632c9cd19c10a7dde7900c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f540b4d8599764882e8dea8c862e6106236432b5e1076b058caee2477a9dc13c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ca3798db14689f51d98726c921e34633cbab664088b04314dfe08f627958866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c781a70f50c0e5616de3910bf263a1cce5f968f5b3c1a0552a704814946b8dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "583089d7bd732f0e42bd6c24a43706109f5de5b25718d24db4b2c12ed6d9b32d"
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