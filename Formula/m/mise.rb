class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.2.5.tar.gz"
  sha256 "e188200b7a4e9b4cef7fe3e1c5ea232b25cbb05cf47e0cce42f94a21e529a147"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0763418e1d1ee36ae91e87ffe47c9f960bb44d42baa6888675bcfbc1eb602129"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "291f53ec6cac52a144af885e874a061a0922fcd69e280ca843eeb10e3e07c9b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a025547087fe710b69fa73aba12199668d539f45fac3c17ef6fc77948b005568"
    sha256 cellar: :any_skip_relocation, sonoma:        "410b1df03ace2a7640bbcdd371a2341f3762412219319de9b7fa002f42162cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76cabadf025dc59ea37906b2ab7f2eab81c3717a57b13a69ef8ff0effc591a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eadc1ce00e08e5b5dc9d135cad31538db97a93a3bb3afdb804aa0104b9bff40"
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