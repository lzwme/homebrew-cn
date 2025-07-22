class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.18.tar.gz"
  sha256 "663c2e7299733a0436541478d57530a8b4cae88a00d379ede69904ca8bc808d7"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "945cb7adb43454d47245e8612e8c3c25e0be2c168632b2251134cd9d1115bc16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a64fcd4d4f60c4748d7655cedf1079949263ceac251a9d80cc5ad6657ad4794"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be8edbdaccd254039b26b64b03144deb3006ef7935347fb58b446dd64d977e43"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8d71d20efde59bc78884730437732d5e10eba7105619842df1978c275b37c87"
    sha256 cellar: :any_skip_relocation, ventura:       "78a80e330df8c857024a12e110fcfd22a9f92a9b570b87b66eba0e2d046348d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74b6f5b3b7a91ff974ba4c85db1b189e416dfd109b4163ec2a0fea0a41ed267d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d289f66e8eed985c331e8d7d35baea95a7af08ff672f2c9d7651ed04f57e2da"
  end

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