class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2026.8.0.tar.gz"
  sha256 "c053fb4f4373712e72505b3b1e2a3088a8fa165e621fd50882dc231feb659a0b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7064d84645ac1479a05a2fbd738c3e246435dde0a317b4451138e4326f94085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ecfb91f41e7bad4d3a989deadc7e0e04e6121c30fe447029650c90ed56fba9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e25d93d35bec065fdb5613dc8bcea3c66b14122bfbe9e23c88a15b42819e7dd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a556998c31ce2f0e0512ac6dcf1bd22c81ae933372850b61d454de54390ad258"
    sha256 cellar: :any,                 arm64_linux:   "feb2efc7a61a8173bda1ee6f16be52f5f705ca114679255ccd481273d9bf13b4"
    sha256 cellar: :any,                 x86_64_linux:  "fccb3a183e4bf3e2fbf0f985e00f28ef36f91e250eb3196b5e8e40515bb5f173"
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