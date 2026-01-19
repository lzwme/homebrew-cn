class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.1.4.tar.gz"
  sha256 "64b6c529dc855e0f6690ad39a05c80b2c1bb17197f24308bb1a8236ba8216736"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4ed7b51473301db1d718319e935fb6b0a2a1278eeda2a7a17a776ccc7b72961"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "609e3b3477c73f7be1bbaaebb9bf16405bfaf8d7e148916429e1337e4a459cc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b8ca9c1f36102fb1854f33d5ab16f59ff618998c085fab9d6f869fc05c201df"
    sha256 cellar: :any_skip_relocation, sonoma:        "142cf2d8dc659ea4f3ef07e2878b64835157761ec527f5df55ee1ec3b313ae64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b348f0ab669d824016afa70af398199b6cda0299ccac317313469548b1cf4706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cb674b378413aee437b3af10918da7da3682873ce7bf5af6333a899bf012a1d"
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