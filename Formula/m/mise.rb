class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.7.13.tar.gz"
  sha256 "0159c5b7cb29b748500c3513db93938fcda4a42f528a6b261a9cc058482b02dc"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fd740891b73aca23270235868110294533a5832e52a9a7b9b5e61f7c70fcbd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8188a134f4f87659f387bc017660c52350a9f2a94d5170de54f05607419e5f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebd3b42511b407cdc0020e8fa97c693bd81dfa9baf917bc6d6b3923223d08ae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e377a4664b7d32ee604ed02537e8ff0d220e4ef309e797684404bb2ebfa02151"
    sha256 cellar: :any,                 arm64_linux:   "32e34e5a3eb304f1403b63230ba84f316b07817c8957853ca3e05cbd48d548f7"
    sha256 cellar: :any,                 x86_64_linux:  "faa2c39185c29da8c407f4c751cbdf841c07611f156ed4a3d836934798b43c32"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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