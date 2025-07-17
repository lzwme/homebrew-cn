class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.7.11.tar.gz"
  sha256 "89867c9371effd1e88c8e293248110fc8f8044081f2bc3187f994c627697b97d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "527ff9c5d0f90f81723c57065ed2bdb7f98863050e486de31f2dbec15e063d3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c0d17677f1aec64a833cad928e3040193fae12900e06241d12ba8d9dd51f553"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87cddc7101749fd3067f4cc55f038cfc44bd5193e12b5fab116694349d6f6f68"
    sha256 cellar: :any_skip_relocation, sonoma:        "aebd2ed6f0bd692d5a374fa9c3b4bb7fc3703f3d9c1f9167a10b54518d4b599c"
    sha256 cellar: :any_skip_relocation, ventura:       "c0cb4579aa3e25895ad9c9fbd8dc88efb88506909229e9332b94d12aeaefb637"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde442f357471eecefc5329904cc9470fc7ff17eea33269cddd4592796170f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5287545675a7f3e57b2ade4f64c5f1aa848aa401082fefb9235c06bab711cf20"
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