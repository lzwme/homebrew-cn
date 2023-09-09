require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.22.17.tgz"
  sha256 "763d265bda25be4a5c5e6c4cd2ed06c6008a0baf01ea30554ec470c5cd4ffc92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77525e17bb2e0ec77698ce7444c85afd00d9cbc7275cdd0771ce995dd22e287a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77525e17bb2e0ec77698ce7444c85afd00d9cbc7275cdd0771ce995dd22e287a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77525e17bb2e0ec77698ce7444c85afd00d9cbc7275cdd0771ce995dd22e287a"
    sha256 cellar: :any_skip_relocation, ventura:        "77525e17bb2e0ec77698ce7444c85afd00d9cbc7275cdd0771ce995dd22e287a"
    sha256 cellar: :any_skip_relocation, monterey:       "77525e17bb2e0ec77698ce7444c85afd00d9cbc7275cdd0771ce995dd22e287a"
    sha256 cellar: :any_skip_relocation, big_sur:        "77525e17bb2e0ec77698ce7444c85afd00d9cbc7275cdd0771ce995dd22e287a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6bcb999238201b550162fda8ec82b736f79550a25cafe498e2cdc0292f6add8"
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