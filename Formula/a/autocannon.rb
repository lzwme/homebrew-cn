require "language/node"

class Autocannon < Formula
  desc "Fast HTTP/1.1 benchmarking tool written in Node.js"
  homepage "https://github.com/mcollina/autocannon"
  url "https://registry.npmjs.org/autocannon/-/autocannon-7.14.0.tgz"
  sha256 "28758141ed3476dfbea824e3f8b84bf89c917619dfebfcfd25979e20cea61672"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06b9f21e1f6f803d43241584b676e7aee3e55cac0c2456bec157eceb4d60a2ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    output = shell_output("#{bin}/autocannon --connection 1 --duration 1 https://brew.sh 2>&1")
    assert_match "Running 1s test @ https://brew.sh", output

    assert_match version.to_s, shell_output("#{bin}/autocannon --version")
  end
end