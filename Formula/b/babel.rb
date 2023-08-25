require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.22.11.tgz"
  sha256 "6a06465820bd9f920a318c7ccf6a1bb0fc8b7ce3fc1c3985ebe612e7f617faf8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b506169b1fd1405af0c794d42bb14973ac4cd76a0a0b4f4c78443240189346df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b506169b1fd1405af0c794d42bb14973ac4cd76a0a0b4f4c78443240189346df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b506169b1fd1405af0c794d42bb14973ac4cd76a0a0b4f4c78443240189346df"
    sha256 cellar: :any_skip_relocation, ventura:        "b506169b1fd1405af0c794d42bb14973ac4cd76a0a0b4f4c78443240189346df"
    sha256 cellar: :any_skip_relocation, monterey:       "b506169b1fd1405af0c794d42bb14973ac4cd76a0a0b4f4c78443240189346df"
    sha256 cellar: :any_skip_relocation, big_sur:        "b506169b1fd1405af0c794d42bb14973ac4cd76a0a0b4f4c78443240189346df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "193fe9ad9b2324cb42b46c6ff3936a34a02b8a9c25064381162fdd20e32aed4b"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.22.10.tgz"
    sha256 "7234890638723e050b6398f31acd75f07454471505856249ad4a728c1738e2c2"
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