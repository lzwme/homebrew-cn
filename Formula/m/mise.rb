class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.5.4.tar.gz"
  sha256 "043ad47304dfc358f1daa15fc0bacbe376901bf986646c4b6be6d3da18eef546"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a37e7b885a591c8b5c91c83d5546908fa3509b2de728283065d0e8f06f912c8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d6a475ef5224d6d530d0cd8ef6f059597a6377a7422d39105c59a430e30836b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8e8293ff8913c95c0b3b96f35ffd7485d6ae5a33eb794d7384f8afd9c32bb14"
    sha256 cellar: :any_skip_relocation, sonoma:        "f878d0fa9cc1f37e00a7e302409f7d99309dae1684e5b1e913ec36ebe5916237"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908c827e01fc3a794edc7a065702eae016e151bdaf80547b5a54c8ef81e723d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edc8f514b0041f8067525396ae06d2c1d5caf213369b9a55d471622a1c8d2cc0"
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