class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/mise/archive/refs/tags/v2025.9.6.tar.gz"
  sha256 "5211c378c16d190a608b834732f917ff5dc6619931b0f87f1dc42274bcce71ef"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4a05e6b64c24f6efa97917edd0acbae82ae7c7678ad71cdf6979662690ae476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "759c106a21094e1270c1c4a1b7540ec3e3b7d45220278eec410e077ccbe4a0c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53e41c7956e8812acdf89c51a128eae13f173724b1c6117190ef596748e524e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8e992d01410ab2a476f6107db09122ecea2cc4c5a3b45620cb17d37d56ddb68"
    sha256 cellar: :any_skip_relocation, ventura:       "62bbeea2853209367de4cccc58b07fa71f62a7eace97c9cfd64bd1eb74802f3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f88410da23093a656039fc0ee7cef3b480aff7521dd975f53d5d0f42069c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "330abd63d2fd54d5f81e5c55486505dd2966feb27cd780c5c10437d632666785"
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