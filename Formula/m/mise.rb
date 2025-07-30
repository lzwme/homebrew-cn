class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.30.tar.gz"
  sha256 "bba4067c33a4e6e83e7a18b7c70cb7800f3506b742103088f768609a1e2bc5c8"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3810d6fb849b87c2a451578a88cfeb0794bea33686191ebe7af07f24110e26ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7e418b049ae36f92d0008750b3cf21e6e8b915a0117a55d3c67027f20f920ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "020e773e697611b5aff8eabe26e175cf779f19df5bf02345e2c5880b97cec03c"
    sha256 cellar: :any_skip_relocation, sonoma:        "17a318bf08fedeb9021e4f58244859e36cf05413d02003bbbd2a3b89e4c459ae"
    sha256 cellar: :any_skip_relocation, ventura:       "1d62976b0fcc6680cb2b7d7eb354d66381f567c299db44c8e0b137393257ba6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aa48ea393ef4457eb2879377b4c74f289b636476f36d77d625e16afd72e3a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a081de190aa2c022ee2c39abfafe8ee9c8a689dd762718e58264966d5260d6b9"
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