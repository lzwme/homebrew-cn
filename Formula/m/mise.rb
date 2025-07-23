class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.20.tar.gz"
  sha256 "6f02eb16e77b9ef6a4fd344f2911fc49643d5e51bb132407b2108e973e1f360a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b6f592ed7bd5c984dba132e70795cb1073e8643add34c5382457399fcddc518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fca4b7b9d194276c56f83e1a31ad2661dd7fde1d2df41b476a60c62e16dc8a9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98808dec5b15325795e23d7d95a7578435cf630750100d9ec45a4b40c4998abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9bd692785c06d2c79dc085dc0ffa5cde8b28cbe5d12b2c786be5f2d270e871a"
    sha256 cellar: :any_skip_relocation, ventura:       "bff7461edd6c4d051922b3e299a891382bb46bdceb77fb9e28d2cba6bb5a90b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31742b83a53fc8297aaf9010dffd0a1f355d024a970d7a5162e64121bcbb59b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e6a3943d9ae8d0b7038e0c9a449306220491265ded9b51184da6645abbbba84"
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