class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.17.tar.gz"
  sha256 "51a59d26e41108d0a8d77752f03658d48bd300ce4383d0a9b80d24f3d8a522d2"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9093b75afa6d2dde8694ca272d205ce76ea76fdb1531d04a437f412704ca5a59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3054cb6612955ebb6e517561b86c8dcb3d7e890b608e5f06ccb20a16b1e926f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ff1cc1142f7f30af650f083add83fb7e5d2ec2ca8cd0ff2abed79e9eedef3cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "22ba5d2800fd4180bc601b1937556dd3de39eb0f277cf08a074ae1a23cc8196e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39b8d04e2a81d9e312a5c845d8e00288ef8422ad6707e7757a591b0d1dfb7592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "405e3da5055d492dca91b9c9e5d8d07a2ca606b817803d29ebf665ee3c9f2a2b"
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