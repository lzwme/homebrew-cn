require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.22.6.tgz"
  sha256 "6201e44157c6b705f92802b7d29ba9927233c06ec79b76d03785624e72e7c16a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa4a7d2e5f3fc6c29b833c696d0a883d4a20c3ed5e4ff91b9cca1c553080591e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa4a7d2e5f3fc6c29b833c696d0a883d4a20c3ed5e4ff91b9cca1c553080591e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa4a7d2e5f3fc6c29b833c696d0a883d4a20c3ed5e4ff91b9cca1c553080591e"
    sha256 cellar: :any_skip_relocation, ventura:        "aa4a7d2e5f3fc6c29b833c696d0a883d4a20c3ed5e4ff91b9cca1c553080591e"
    sha256 cellar: :any_skip_relocation, monterey:       "aa4a7d2e5f3fc6c29b833c696d0a883d4a20c3ed5e4ff91b9cca1c553080591e"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa4a7d2e5f3fc6c29b833c696d0a883d4a20c3ed5e4ff91b9cca1c553080591e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be18b47539d3e47dfc0f4189c91395ea5e25d9c02968dafd881810c08be7a8d"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.22.6.tgz"
    sha256 "0a078845e29db377e71a42275524a5ad62bbf82626b6b05616261cf7b8a7935d"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end