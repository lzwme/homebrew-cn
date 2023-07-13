require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.22.9.tgz"
  sha256 "695fe6f6563507089c29ac9d6a289638a17aa4ad59963a5c8876e04cf8c78416"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5098d6a31f682e7718fa80d592b4d500b0165720fbe821e25946b5abc2724614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5098d6a31f682e7718fa80d592b4d500b0165720fbe821e25946b5abc2724614"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5098d6a31f682e7718fa80d592b4d500b0165720fbe821e25946b5abc2724614"
    sha256 cellar: :any_skip_relocation, ventura:        "5098d6a31f682e7718fa80d592b4d500b0165720fbe821e25946b5abc2724614"
    sha256 cellar: :any_skip_relocation, monterey:       "5098d6a31f682e7718fa80d592b4d500b0165720fbe821e25946b5abc2724614"
    sha256 cellar: :any_skip_relocation, big_sur:        "5098d6a31f682e7718fa80d592b4d500b0165720fbe821e25946b5abc2724614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6c6090fc178f2d9e5ad4d84cab8d40c1f15fd359ba229f91ac79bea2cbac977"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.22.9.tgz"
    sha256 "9d38f3cf44b17f07d6266760bf782fa8292872faf051525e753d6fe3bf67890e"
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