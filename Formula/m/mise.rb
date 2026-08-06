class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.2.tar.gz"
  sha256 "4c35c9f882d5672b7cd990ad3a4e5eb2607d67b720697e3ed7f56c93e0a91b05"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e68c03596f7089005c7d069721f59f6d967cca78c092de1ed1f4661f19a29e65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08fb0929c4460d8d1e2368c7578f0c8bf9172bae4e7011507e6e1823eaba96b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef1cfae0782ca92673a6312cf113619d44ff980cd5ea7ec415d55544f1f5a8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fe7341e205e0e02db572806f5e783919f02e5e1b98f02f8cb3b776f7cde4500"
    sha256 cellar: :any,                 arm64_linux:   "2f137c3a4ee4e77c388a00f1481b1ccd8a25580e41ecf8e2e8e8f7f513f09e2a"
    sha256 cellar: :any,                 x86_64_linux:  "7903db082d0f669e93c6fb0d58679823e423059298b6ccfce5cee7d7b63733fd"
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