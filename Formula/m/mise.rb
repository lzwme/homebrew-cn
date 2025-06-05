class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.6.0.tar.gz"
  sha256 "9b495ba075165f07d814b75f64635e1c9cdf18ae1aba786514e1716d4ce9e743"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbb8ea8285af9658366eb88c2da2fa989c7c85b59647e48cad30a9684b2b1d08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edfbc87aba309bd687849240c2a72aacf0a9400da743afa081200e28354c261a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b5d67b9bd795db4b86be404551caf496570f52dce8913a756eb37d678aff050"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae7d5ce23ecc4f3b04a683ace21410b988842ee2fa11e1032c9787ab2f12b05f"
    sha256 cellar: :any_skip_relocation, ventura:       "81f925ebec7acb19c08b5b0f4e14a4b0fd26c67d58519366cfd2ca3b4d170565"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "472921d99a84f0112a0d450b62d1ff59d857723ced90ff5083ea28990e02a400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b49874b20feabab20da392f6cbdc1b391dbff54a11bed5df197603db78f68cba"
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
    man1.install "manman1mise.1"
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completionsmise.bash" => "mise"
    fish_completion.install "completionsmise.fish"
    zsh_completion.install "completions_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")
  end
end