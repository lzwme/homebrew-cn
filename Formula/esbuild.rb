require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.8.tgz"
  sha256 "24e19ead9ae7b8d17124be681903083c2f01bd4fa6f8bbde058916c84da6ed88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fe728c05ee17830370af34807b6c58e05a2cef689a15eda9252888654e3a738"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fe728c05ee17830370af34807b6c58e05a2cef689a15eda9252888654e3a738"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fe728c05ee17830370af34807b6c58e05a2cef689a15eda9252888654e3a738"
    sha256 cellar: :any_skip_relocation, ventura:        "0992a4d36826bf87e9f3d952a50b8f5a526761f0a06c791fa94dc906d456f757"
    sha256 cellar: :any_skip_relocation, monterey:       "0992a4d36826bf87e9f3d952a50b8f5a526761f0a06c791fa94dc906d456f757"
    sha256 cellar: :any_skip_relocation, big_sur:        "0992a4d36826bf87e9f3d952a50b8f5a526761f0a06c791fa94dc906d456f757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34af4d030129ddb8022181b73ff81b41c17c6a614c90ab2364ebc75ab70a30cf"
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