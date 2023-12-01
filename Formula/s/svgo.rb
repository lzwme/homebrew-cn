require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://ghproxy.com/https://github.com/svg/svgo/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "005c4ebd99f3a10d32328738c3756b7f594380ab5fe9da0562cc0b3612f02c94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "599b0651756119d2af116bf1887df50b136afc765309a276b0edcf3ca26dce59"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end