class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.4.tar.gz"
  sha256 "87c85e60b2334b2ad93f0ebe9ddedd36c311639b98c22ae36824ed3e5c444e89"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91518286bf82666790b1b27c91d81fb0d6eb69c77083da12da7d6ff4a61ee0b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ea6b0a7be8dbb0b09183d05be60e7c85eba65136a1de4fdee87bc3483abc89b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9b31c2ed8051ad0f6d0cd598d561db9549a810538e960b3e15d9a1623316c69"
    sha256 cellar: :any_skip_relocation, sonoma:        "09bf8817c6527e27373cc1cd4164ba6eed14fef72133fe5daca3bab130a35ba3"
    sha256 cellar: :any,                 arm64_linux:   "c1b05502a5895e75ff5fbd358c04b8356d33eda1d136ed4baee36ecdbfa1e19f"
    sha256 cellar: :any,                 x86_64_linux:  "1bec79f44fe672cc1fe13ad7200919617e24d8800269f3172af7965e5788d9c4"
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