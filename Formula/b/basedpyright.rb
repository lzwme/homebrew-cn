class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.18.0.tgz"
  sha256 "442f74048f5eede51937f276dc37a08cff833ab45f8704b2f74711a901e5c571"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd66d619bd5d0979fe55cad1c1bef7305de87e896fde068b33c088336cc2ed96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd66d619bd5d0979fe55cad1c1bef7305de87e896fde068b33c088336cc2ed96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd66d619bd5d0979fe55cad1c1bef7305de87e896fde068b33c088336cc2ed96"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd22c0ce79249c650659fc582f46b299cfad8dff9fdeab69cdaf22ca5130a154"
    sha256 cellar: :any_skip_relocation, ventura:       "bd22c0ce79249c650659fc582f46b299cfad8dff9fdeab69cdaf22ca5130a154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd66d619bd5d0979fe55cad1c1bef7305de87e896fde068b33c088336cc2ed96"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec"binpyright" => "basedpyright"
    bin.install_symlink libexec"binpyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}basedpyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end