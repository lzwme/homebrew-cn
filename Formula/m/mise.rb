class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.10.16.tar.gz"
  sha256 "c05d929ac6f352f92d65c24febfc852253cd8504d4afdb38bcf3df5c242934f7"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5f61b41705932929afdbb131a851a9c3f8b4b04b049d18b440dee106c2a0bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c873c89923fd7c966c1c47bf6f6be9d30fe6e86b9bea90f428255b73ea0cd06c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2a04961874bf71884ac41a4b5aec7e1ca6d525b7c3f38b797eed3a8d1ffebb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "46991c0216db715d716389df547201975c28c6e111204e2c1409210217d0e611"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b72a94da2cdd8be9aa010a7ecacedf5cafdd86f10d941b8beeea17f4a6a95cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5f732dba665c231bd853a9cf09626b65850a107f61bf2de20f8775d13562aea"
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