class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.3.tar.gz"
  sha256 "8cf21c3bb673bc01542b270d4fc96a105e368611798048582c26f386c7d519aa"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d32d9fa737b73d873c3cd51e738c2fc62ae7fbd4c013f5a7631ce2aa73154f3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5247ac9c632c687dd6488a319233bbab0ab85882100f8bab54af18e4b46c2646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e443c9718c69934408252f137d1c0a9adb4a49a07573bf74b11ca34a2407eb75"
    sha256 cellar: :any_skip_relocation, sonoma:        "234a6774fee9ac75f1d38fc21da9ea45d0518c42caa752d15103ca7cac97fa72"
    sha256 cellar: :any,                 arm64_linux:   "597b5e5e5a61a6c8897ba9493615995c1a17d647712ab4cf5caffa4649aa5a11"
    sha256 cellar: :any,                 x86_64_linux:  "1da962594abf918ec6f28d55cc5e5244e8ddaff06113ee1c2b5a7af85c8a32d5"
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