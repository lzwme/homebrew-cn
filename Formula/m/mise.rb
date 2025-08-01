class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.32.tar.gz"
  sha256 "e3b9e9883ba1fdb765246a3e6a6be24641f827dfa55e5f816ff98551b2460790"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50da8412a7630246d7ad88aeae6ae70d7d78161083910c9c86b7d33e4f8cb41f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46972633b7b953cc90ea28dc5f9251116f189a6cf49c86d8b73b81d8723a8875"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b99b4c403ce09b3a3a004e167b878345ad64c74d77548870bb138850f74981f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a76ed63f84464390417f723aac3a389680c2db187fba94a85f29a674f3b701cd"
    sha256 cellar: :any_skip_relocation, ventura:       "ced15f8064eb434d1112e12b0748d88e6f40d8f1609673212614b83b637a96b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7e4ce7f55cb74dd86b8a319e3e738bf9eaf1bb815384fe3adef7282776e90c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f0117bb3af1ba29ef8609893d78e41a51a672a12591686d4994fd397b3938f"
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