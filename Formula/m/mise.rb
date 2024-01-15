class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:github.comjdxmise"
  url "https:github.comjdxmisearchiverefstagsv2024.1.20.tar.gz"
  sha256 "29ca573a77f256c220817eebbf16fe61af944620b869dbce8472880e64bcbe16"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f254828e70f292812a49d492db72c0d3a47bfebdf1cc14df968d7af1173fbff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04814d258d1d1b17f3ae4d08d3950734399992ef0d92920fc47ec433f96cf18f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0ee293f6b2232e05030da0b36f15558e51534305b77a07a1171aa99e457f392"
    sha256 cellar: :any_skip_relocation, sonoma:         "32c1a0a59c81705049917782227ac295fdceaaaf04298ba720b5032b5bdddb03"
    sha256 cellar: :any_skip_relocation, ventura:        "4cbae4a045726293224a87a95fd0ecc98e98cbb8514a3059419a79dee100ff5a"
    sha256 cellar: :any_skip_relocation, monterey:       "23e91a69fc01167a24116e8b26846eacd144e78b4d370023b60808427f17f5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e86b6e2a95009fea1dc5c2240ac32d309fa5342059685709ce5d294cff2ff9c"
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