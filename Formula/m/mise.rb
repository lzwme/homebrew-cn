class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.8.tar.gz"
  sha256 "fa1ebfe0821370f451ba6be580336deb87751805d0861a60d38ffb8d23f5e945"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2a2ba30e7e73aadefe41193cf379e888622ab6053a3e495375f5176675153a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e17cbc7d6a6b2ac925dd4c42475f9a132aa0f3e0f4801fbae9d5fc9cc01ce49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14bbcffcb4d198980e7e789ea9835dc09069334e448f2b475bf5fe8e010af922"
    sha256 cellar: :any_skip_relocation, sonoma:        "adb4eb95cc7935d849403b4af9c7077b3afcbfe15f9f49f79bf4f2eb8542f363"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "957592dbb14923ead139df99e350be3260fa2fd76bbce07a9aa743712fc0bfec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946dbee766dda8ba74bca4828913e4d1f64701a54d03a3ac84f76831dcdb1d70"
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