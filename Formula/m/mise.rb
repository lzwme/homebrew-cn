class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.3.tar.gz"
  sha256 "646ada3451e61b4a9fec0133c2f138cfd4af5a8b9fb56a70648f452124221f39"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6450764d5ef35acb595fe971f5582f8268fc50baa2003e9bfb6fc6f70319b0f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2d5f1d5caec49304a60a35adfcfb2f98fb6161d2d60aafab005182b86676b26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad5c452037479ddfcb6f145df4f3220c4a5370e02b42ed51ab41c08c50996e90"
    sha256 cellar: :any_skip_relocation, sonoma:        "3233f14d6998429b5e129b262b817fe6fbb1cfd2e6ce8bd849b3052bd68874ed"
    sha256 cellar: :any_skip_relocation, ventura:       "81c7da6de44a30811e0651de683795fbd5bbc4a9a9733f67f6c9d6361cb9d3ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "335df886c49dcafbff980a68dc9049e4c347e46459309b12f2490a6accd6ed3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccbb83416c03e722840ea8b02ebfe1bcda5ee5fdd75a21676b99bd04e35155c9"
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