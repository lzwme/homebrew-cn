class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.9.tar.gz"
  sha256 "d69ee7b367bffb9ddf66bf403131e50577f642f9a428572020610bd5fee33e52"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79c90567013b30b0eab2a130635cc240c7155c9202f8e41c0516b55974709b38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59dd292b45a3a2f56ef33c77cdb6560b8d69db72e65202c758eef2f3227e9146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58d99a3cb9f6790d32c5aebea1e6fd67890180948f64dceb129bdefcc3f83c26"
    sha256 cellar: :any_skip_relocation, sonoma:        "b045f1953ec671c4e398330c7d92133e1643a49b497a53b90cbae2d694fc4554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5862c2d41480400381731edefc21eb6165f15bba951cc176a9c5c171530e7277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b38e47ea8514b91728ec1ac9cf5e564b2530c23216fe7c9ccce01e7a3d386b6e"
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