require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.1.tgz"
  sha256 "24bba79d6f7c6d057f39e0220771e9b572971fc1fc196c47ac71e7ef5bfc739d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1ed9cd4eb3c53775b69ec8f458010bc5e0a4a6953bc0f0dcb6c44328dfbca0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1ed9cd4eb3c53775b69ec8f458010bc5e0a4a6953bc0f0dcb6c44328dfbca0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1ed9cd4eb3c53775b69ec8f458010bc5e0a4a6953bc0f0dcb6c44328dfbca0c"
    sha256 cellar: :any_skip_relocation, ventura:        "ca7c801838572c855b9e4846fee159a5e3df63e4f06d5b1606a065cf4b17c85a"
    sha256 cellar: :any_skip_relocation, monterey:       "ca7c801838572c855b9e4846fee159a5e3df63e4f06d5b1606a065cf4b17c85a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca7c801838572c855b9e4846fee159a5e3df63e4f06d5b1606a065cf4b17c85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dcecc440f44e624c484d533dbf6ed6d64addb281c4f6b733e1d37478d80ec16"
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