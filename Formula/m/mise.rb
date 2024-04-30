class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.4.10.tar.gz"
  sha256 "026a654f6cd94faa217c5a0da5865376b8bc11248109536b0a85c86d027c408f"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c4307a703207af5f6b0e219414e260ea0a813867e5ace9e81d3132d756a6d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e81daa952a504a3461079cb46ffde8fc622a958f8591ec3ca69d6e7c132c4111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45a271ce4be69f303109e75c3298ab8ede2d72377653310def686cba8e3509a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "b01e1916772b866c89213cc70f2337cded845209eeff70f5f4011694b0169e16"
    sha256 cellar: :any_skip_relocation, ventura:        "d4c19ac29f3ca4c18b8dc42a46fccdb9afe1b091a8ba91717b9b2e0ea68672c3"
    sha256 cellar: :any_skip_relocation, monterey:       "24de7d4e76d26d390bbe949fa148e92c6312adee3bd5e5343355312feed80bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "041893646586b4e2150b211c7ccebedfbe196f340a3cb3e5c9b7f32ae71bfe5c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}mise exec nodejs@18.13.0 -- node -v")
  end
end