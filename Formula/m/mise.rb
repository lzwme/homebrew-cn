class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.4.8.tar.gz"
  sha256 "27623a77ec013f8e50ca85c41ff4c86270c2c04323d6199a3b506de73c9a3bb5"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8879e60db81266597903afc348506598ae488a83d9c5553920e10d30efddbc4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e71f6572fdcaabf2b5aa590c5a0956953869eb455d4372d28f4bb96b9700b0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8e6aea5e4b041267259a627b4aefb16878c4ffc30f5dc2af148a476aff4ad0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ace71b05af4e47c1d90af140e6728527469dc9e054e96af049ba1909d520c60a"
    sha256 cellar: :any_skip_relocation, ventura:        "e6c689d726f9ff331ef564caba0da5e80297eede63ce2fd57a781be31d3ee668"
    sha256 cellar: :any_skip_relocation, monterey:       "04d3564bcf185a6ddfabd2489048a755327340b48da3a6f381e35ef32aaf06a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54c9185bd47e7cfe8cbe14c078fc4434fd7d5cf5e9c70cd335422208d533956e"
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