require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.24.0.tgz"
  sha256 "cf810a424622b37f2dc023ccb1aed9200c71286c000592483daa3e9826d01943"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, ventura:        "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, monterey:       "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd20b81f2e174261198180a6a71969a6c0c9db170a9cea02482985ca6b3c1cbb"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.23.9.tgz"
    sha256 "095234aa8743f03e4baa0a5f2938ba4bb1e32bdbff0df3ebf00f9772d257d49a"
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