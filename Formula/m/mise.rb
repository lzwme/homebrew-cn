class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.11.1.tar.gz"
  sha256 "fd5ad5304b2d65954f1651d9788f8c8ea99f88e4b4e25fa0ee03b1e0b42eb74e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "068ec41e74c6d5671c7d04347a9bf8594e2f481b9d02ea029b7bccb82f8b58bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "841bb4adbe752090718024bf313db3d2d491a58f97f58e8307a7dc4534b447c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4accea7d9ac0897523deb20b48b65641af3d151838afa44e81bf832f8279cb1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fdfc04a2a5de386bd53624702603f085efcfcfd3209e340107645070a5db5bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e22f20899a061d12eaef798e995102a35c629f64dd4e8ec259baca311607cb97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7df4420789c767b253908c0b7e1e6cb362a0d6531cc783eeb25eca51bfa37702"
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