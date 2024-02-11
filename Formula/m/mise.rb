class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2024.2.10.tar.gz"
  sha256 "7cc60f9ec818bf5224bf242d1a22ab84de549cb66c3accdd2050f5d5675ea698"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4478941df2e91171d30f61cbe9789fe127972ed6c6e16d2576d621d9b7dee9d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8de84c135da6b5af8f0a7142e7c1927ca7d51d474283171b244468198642585b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9965902df34ddc23690025fee735fa48aa39e48fb8134cca520f3dfae2cf13a"
    sha256 cellar: :any_skip_relocation, sonoma:         "dac8fd8a070594bbef11dc82595031f4e2732577e0bee7553d3857faf27b796e"
    sha256 cellar: :any_skip_relocation, ventura:        "ae0e1674a42916e0de8c99c7b59d49505e9ad6d623de17ee3fefebfc6bf7b9d0"
    sha256 cellar: :any_skip_relocation, monterey:       "596a6aafc89ed9cf2959f08ed1bed26cef0976e5c3190e93302da50ee5d051d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ecb2f92d42fda3333ceada3752816edb53414d0f74fc6cfd0d06280be5914e"
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