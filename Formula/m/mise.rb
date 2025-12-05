class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.12.0.tar.gz"
  sha256 "29f37022ebfeda323cba1e40c4a8603859e3fbd59ea7caa591cbc18d3d49314d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86cd50a2bffc91d53661c2d78f389488e020b8832d8544b4cc6a8a8a86fd4edf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cfdf059ed986020313ea4a4b5b635d4682caa2513c7fe866ee40815e6d86cd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dffe4749f6cca40df97863c32a3248002eaec47f18e96e1386125d41bf8c8288"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7b68d87e1b60eed7d41eb3684cc5b9b7ce5a8382f32e31d40467fa3e7c21d72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce6a886632aa787e148592a9043e3397a5e02ef3d0a7a49b94ea389df8311c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34f66fca007cea3a87856a679c7795f693204f65156224a7f70bfc418842d0a"
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