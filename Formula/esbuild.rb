require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.0.tgz"
  sha256 "804450dc9a0c19bf02d46c47223dbc147661afe73ce5910eab77d35a527a19ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dd7da1b7b6bed426c9463772450a275d9c5434583c4095ee3a571a8c293fc22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dd7da1b7b6bed426c9463772450a275d9c5434583c4095ee3a571a8c293fc22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dd7da1b7b6bed426c9463772450a275d9c5434583c4095ee3a571a8c293fc22"
    sha256 cellar: :any_skip_relocation, ventura:        "40ae6433265edfbd254f68372a9721c53657da1a3ac1615d37498f56b6cb637a"
    sha256 cellar: :any_skip_relocation, monterey:       "40ae6433265edfbd254f68372a9721c53657da1a3ac1615d37498f56b6cb637a"
    sha256 cellar: :any_skip_relocation, big_sur:        "40ae6433265edfbd254f68372a9721c53657da1a3ac1615d37498f56b6cb637a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c72d347bf5ae9a963f7844c4e64eefb4eb46488366b5eb0f3e96b56dd3f6896d"
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