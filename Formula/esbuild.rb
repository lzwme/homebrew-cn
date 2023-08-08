require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.19.tgz"
  sha256 "dc9c3908c44f149bba3495f30347682695fe98617720cc8cd09a25336e9ffb7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7e3cfaf63a2df878dff1c5ed9af162d6b95a572cfc02da438e0c3a93d2842a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7e3cfaf63a2df878dff1c5ed9af162d6b95a572cfc02da438e0c3a93d2842a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7e3cfaf63a2df878dff1c5ed9af162d6b95a572cfc02da438e0c3a93d2842a1"
    sha256 cellar: :any_skip_relocation, ventura:        "c74799598ad28a865712393acf8ffcc35b92524ad1a3b1dc54574f56259d7c2e"
    sha256 cellar: :any_skip_relocation, monterey:       "c74799598ad28a865712393acf8ffcc35b92524ad1a3b1dc54574f56259d7c2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c74799598ad28a865712393acf8ffcc35b92524ad1a3b1dc54574f56259d7c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d70df446d14fab821306a1fb78b34fda1a95fc7ca02931ac6b9de5162227f9c"
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