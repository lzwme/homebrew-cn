class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https:github.comvercelncc"
  url "https:registry.npmjs.org@vercelncc-ncc-0.38.1.tgz"
  sha256 "0633a7c007ddc69becffd112e5e8a2afa0da0fbf7d6e085122f2ae90e63847e0"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "5ce7d2e4debb0cebb3a89ebe4740f32ebaa8f57425fd347a1086b2e3a2285532"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"input.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin"ncc", "build", "input.js", "-o", "dist"
    assert_match "document.createElement", File.read("distindex.js")
  end
end