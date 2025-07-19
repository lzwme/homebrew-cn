class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.16.tar.gz"
  sha256 "37d927f2e4f19e3ff7482cb44877835f45e6180b44f3b36469238549bce8bfeb"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5fe2d1e4f5d19cbc5d8c50c7e9dd5e8ce3ec18c053383a4886b9c52683d8e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea87fb65d70f707c221d83a5bd241c09703116c510259daa8347e05e0a9b762e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0395e146e4ff356dee882816b256d69b77a3038370021085ac1ec0e504e39f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bce84a2fcb8bb3a936747552d57ca37045aea0684c0441ea4c253c1b8bc65c77"
    sha256 cellar: :any_skip_relocation, ventura:       "9bf5d1ee4428b93817d55fc6848fa2929376aaba3175348b6a73ab9816937563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "349c88795aab3d64055768fa466fe547be3910f34519134dfd98a59f3c7c83b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08636f66a6f52d7d4c8c07e412ee4a8c8923a3009d3be33a7aede44bb50bba84"
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