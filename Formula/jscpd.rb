require "language/node"

class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-3.5.5.tgz"
  sha256 "1dc1ad89188cb76bbf91cb6ce0c020791aa06088cdf747efeb47ad0160154e37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "147f539883a39898e14f5dfd1bef62d3ae4fa020ff3f6c15281e4a19ecf86028"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "147f539883a39898e14f5dfd1bef62d3ae4fa020ff3f6c15281e4a19ecf86028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "147f539883a39898e14f5dfd1bef62d3ae4fa020ff3f6c15281e4a19ecf86028"
    sha256 cellar: :any_skip_relocation, ventura:        "f970c837fe05644210519136f54559db2bdcfb5ab018e38b57a182f5d033d9b2"
    sha256 cellar: :any_skip_relocation, monterey:       "f970c837fe05644210519136f54559db2bdcfb5ab018e38b57a182f5d033d9b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f970c837fe05644210519136f54559db2bdcfb5ab018e38b57a182f5d033d9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "147f539883a39898e14f5dfd1bef62d3ae4fa020ff3f6c15281e4a19ecf86028"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_file = testpath/"test.js"
    test_file2 = testpath/"test2.js"
    test_file.write <<~EOS
      console.log("Hello, world!");
    EOS
    test_file2.write <<~EOS
      console.log("Hello, brewtest!");
    EOS

    output = shell_output("#{bin}/jscpd --min-lines 1 #{testpath}/*.js 2>&1")
    assert_match "Found 0 clones", output

    assert_match version.to_s, shell_output("#{bin}/jscpd --version")
  end
end