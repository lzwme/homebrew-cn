class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.4.3.tar.gz"
  sha256 "c588fc4d37a95bafc40207ccc14d412a0a7d677c2cf95acd05135a29cbf57bcc"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c091fb7442490526da474885ce915b05a5b3ad0ec11d14adc5a25a5b9165c989"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eec001ee5601fa0ca67bc76b6f52cb93d4903a6981897c30afa0721c83839b35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e65d3d66ae4f6a46ff0677a41bd268b50f70b71aa95bc1f7a6b04d2caa61eaaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "7690681c15f1524552a48d7bd266f97c2d1aaa36b9d0481f47bfa93e77379321"
    sha256 cellar: :any_skip_relocation, ventura:        "e6a7931c9add51151aab93b763e928e08df992741efe9bb2ab7085b8772e0483"
    sha256 cellar: :any_skip_relocation, monterey:       "26dc3725a4242db964c5f9743d75ce107f1c1ff6c8b983882d40ec1451b27f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "927991c455933332b946e8890ede9fd452a960985777be057346d17ceb0bf75c"
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