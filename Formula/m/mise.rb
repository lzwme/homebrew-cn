class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.8.13.tar.gz"
  sha256 "519e8ccb656aaccd6a6599056df3d7218d025bdce9923f83c5e24db15f3e41e1"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "016bdc4ba0e0918ca2e784ed151a5c88cc5721ab40b7428ca3e74f54bff295c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ffdc0c6ad574acef24d8aa86b480d57e262afcb1d3cde9a8b7e2dc10a9c7676"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50984b3420377343056221eb519ad8c9465fa9649d5f8bb4c94c3ddb323a2369"
    sha256 cellar: :any_skip_relocation, sonoma:        "550924824d132220ce2df2ef4600903ff98720b9597edb1a70ce70c7fff6ce2f"
    sha256 cellar: :any_skip_relocation, ventura:       "7eb2de7a6d2456a2705744bbe0110b5d838f28397797de26250ce1fe11eee900"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6227f6ac666fb3d798db0cab41f9ac2ffd98098cc20f85bc798f04a38a54d1d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "442438f108237c31ae7dba063841bc1fd0edaca9665f559ccdc21fcc6b984dd2"
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