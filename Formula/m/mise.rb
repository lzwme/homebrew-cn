class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.11.6.tar.gz"
  sha256 "33d997efa585fd477caa31815c0760528a892f3ef4ab5e855e8cefe281484a5b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e03400dec4e1e6e763695e9741da58e34a00a472d6965ec1c91634b4c3f4d6dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0a54db96ac6c7945b8fd19a715c114606fed0e83871c4631355b05c14568e5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b7778e7c0113eee65adf3717bf03cf0ec9fb4ade5c03aa892ac895f0a11e733"
    sha256 cellar: :any_skip_relocation, sonoma:        "18e7296637e007d19c30661f8008409c5784cf5a8a4970b2ba21c8d54a5c0bba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "836bbf7a4bb566d5123394f37d2af35dbc8cf855f90c183a5ba09e39d7d46d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1d6a7b126339d73eb41b93bc16f1d6e367b988aaa228c2283c0ad802bf6e730"
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