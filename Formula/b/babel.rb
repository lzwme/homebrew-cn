require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.22.19.tgz"
  sha256 "54e851ce1f40903b2265c42cf325ac92d3bc36958cb85e204d4794a9a49c86cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa4a51ea57957e2d711164711068b05af2191d2996f8dbe2f63fa9c542a278d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa4a51ea57957e2d711164711068b05af2191d2996f8dbe2f63fa9c542a278d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa4a51ea57957e2d711164711068b05af2191d2996f8dbe2f63fa9c542a278d3"
    sha256 cellar: :any_skip_relocation, ventura:        "aa4a51ea57957e2d711164711068b05af2191d2996f8dbe2f63fa9c542a278d3"
    sha256 cellar: :any_skip_relocation, monterey:       "aa4a51ea57957e2d711164711068b05af2191d2996f8dbe2f63fa9c542a278d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa4a51ea57957e2d711164711068b05af2191d2996f8dbe2f63fa9c542a278d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d37b788f0f5790161f0d1b28565842feab2ca89167cbfdef076a07f5982d512c"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.22.15.tgz"
    sha256 "6ac27dc7ff329c4c21813e71686734ce57721c8ef39b526a14617a4e1a6e7c1c"
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