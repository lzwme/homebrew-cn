require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.16.tgz"
  sha256 "b771673028dd6aba43e742653822c40244701ddf3f4a2871e2f9bcaf9555ee14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc135371a2c9f4d2fb4f27d0a58339d74d7c1157b7461c90e652b4f49bc5ff9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc135371a2c9f4d2fb4f27d0a58339d74d7c1157b7461c90e652b4f49bc5ff9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc135371a2c9f4d2fb4f27d0a58339d74d7c1157b7461c90e652b4f49bc5ff9e"
    sha256 cellar: :any_skip_relocation, ventura:        "ddbd4f81ebecf18d780a96c14543c0fe4c8ab2113a1d3d9f4d8e265002a57456"
    sha256 cellar: :any_skip_relocation, monterey:       "ddbd4f81ebecf18d780a96c14543c0fe4c8ab2113a1d3d9f4d8e265002a57456"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddbd4f81ebecf18d780a96c14543c0fe4c8ab2113a1d3d9f4d8e265002a57456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10971ed39a68dfa55f7bd9df763a651db6a9274960a49ed1a43739c9769b2034"
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