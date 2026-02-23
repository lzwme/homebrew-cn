class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.19.tar.gz"
  sha256 "217fd7b2518e976e6eebd0435bba05fadb122f441ba16935b834893131d13097"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f80ca7d3c19f58cf3012ea596e1ad5a5fc44866bb061c107fccb449d52956d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "857dcbd8d3437744a0ca8fd882a067dd36cfe9775889f4907dd3192bc37d39b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da212aa423ac28e21caabb617e9a0d7223eaffcfc10a5e8a575eeb236a763bc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d10cff66ceb440762496b65df09b33b58b7aad855a693a96e693e5068c8d6ee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce6c863afa99c87c11d491be6531f2f34daa314423b996df1aef670543df0025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a16900a55d1f415865818cc35eb04bd1c9e5707412905ca1f8faa127486d35c"
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