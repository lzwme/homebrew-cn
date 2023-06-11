require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.0.tgz"
  sha256 "c001e14748e9a5c91851f165631e9dfeff55b208475d8ff467828ae5496bdfed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8649f5860191055cda63ac1857d850bb4178cb208464d35344e500cb23d84073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8649f5860191055cda63ac1857d850bb4178cb208464d35344e500cb23d84073"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8649f5860191055cda63ac1857d850bb4178cb208464d35344e500cb23d84073"
    sha256 cellar: :any_skip_relocation, ventura:        "7d44c37f3d2b648f06a225a5ada3415752a00a7df4d9ce661eb17ed41b54d86a"
    sha256 cellar: :any_skip_relocation, monterey:       "7d44c37f3d2b648f06a225a5ada3415752a00a7df4d9ce661eb17ed41b54d86a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d44c37f3d2b648f06a225a5ada3415752a00a7df4d9ce661eb17ed41b54d86a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f179762359bf9207add6dc11337026f9d9fc2f87b4d447a7aec1e1de6ebf97d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.jsx").write <<~EOS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
    EOS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end