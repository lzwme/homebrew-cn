class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.12.tar.gz"
  sha256 "073e499ac1189954ee55f61fbdc20d2dd7b879b982313f2669cae3f0c215043d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f84887e9233082d6c5d053437aa40c7a6752ea6ec07dd538e73ce4560b29a40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "718eda8ca52a574a12ee0b826ba4f3101eb4abbba642e3c5057d991ae6bd3be8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ca4fcb865522fb6c9e67d3ab225bc31e7af8efac71f79f99b6dba4409c2e20f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9128851619ce8587bfe17c2a646c8fbd074a13c252c9888ecdbf44f911458c0"
    sha256 cellar: :any_skip_relocation, ventura:       "6e1a6281befb1636374cf0c3fe818eb7742a4722ca7f317e80308b773160b2f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "201ca8979595d5f55262dd110f2ec5ab0ac1e1cac3943fe08b9422fb272030c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efea660df12bd3ac56c65d0de01c2e4b79c4bc22fbf7ebc9827169c6f0789819"
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