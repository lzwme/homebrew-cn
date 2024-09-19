class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https:github.comDetachHeadbasedpyright"
  url "https:registry.npmjs.orgbasedpyright-basedpyright-1.17.5.tgz"
  sha256 "f5f02892955bfa13035bce0e63dfa0f3b7ad17108fb1b6f170488853eb6a6770"
  license "MIT"
  head "https:github.comdetachheadbasedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7151a216a9bee4c1fd623f86af276662856602a17863469bdaf2f1e8da951ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7151a216a9bee4c1fd623f86af276662856602a17863469bdaf2f1e8da951ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7151a216a9bee4c1fd623f86af276662856602a17863469bdaf2f1e8da951ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "d465579a903c16ef81485afcd0c621876e5e51e43540cfa4657d329e1c5191e1"
    sha256 cellar: :any_skip_relocation, ventura:       "d465579a903c16ef81485afcd0c621876e5e51e43540cfa4657d329e1c5191e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7151a216a9bee4c1fd623f86af276662856602a17863469bdaf2f1e8da951ac"
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