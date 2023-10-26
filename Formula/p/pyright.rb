require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.333.tgz"
  sha256 "3bdd531755bb4d13c206399e81aa19dcdb44aa27bb82b5512c229d99869df938"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "163a2bf7ea38f8bb7859d3885ae8bd0334070991cdec21ca04bd623c32624c7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "163a2bf7ea38f8bb7859d3885ae8bd0334070991cdec21ca04bd623c32624c7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "163a2bf7ea38f8bb7859d3885ae8bd0334070991cdec21ca04bd623c32624c7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "054ed51542808606a87ea1082249798c967022d58079d4f53eaaa2121174c62e"
    sha256 cellar: :any_skip_relocation, ventura:        "054ed51542808606a87ea1082249798c967022d58079d4f53eaaa2121174c62e"
    sha256 cellar: :any_skip_relocation, monterey:       "054ed51542808606a87ea1082249798c967022d58079d4f53eaaa2121174c62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc3d3619fc4c1b7e9c213fff85fa45b13c1484c1c85e552f860b4905f578d4e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end