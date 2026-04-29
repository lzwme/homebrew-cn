class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.4.25.tar.gz"
  sha256 "02295fd904d2b94e8a86b35b9e274cea8a7b661a60f8167b7504b2e3cfc60eff"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80baeafa6130d407bd3e13140c6095d8ade17fd59d144a4935219bd60f452667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df8da49ff0f0efd67f56cf4af49197bb8bc871d80324bd854af9be48e1719a45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd1f4df187c4425c71550f207e63db7975cd0e57cdaa83fef3e3ffe041248379"
    sha256 cellar: :any_skip_relocation, sonoma:        "da33f9cb8f250e44c344cb960d583b6052720f32842cc10f1d8abcb91c750b70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91d20fa126e4f03a19cd27b09231f08e0fcaedbb872651749d9fcc96543149bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038fddc326b99458499735c39e19414743503a8d815208778c7f11678080d1d6"
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