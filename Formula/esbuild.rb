require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.9.tgz"
  sha256 "8beeab2fcdfba9bb2ca3555bfa4b5db41bb395f290ea6e51c4f2fc06f8668dd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a09aab7cd11f62a9e3e470f29d84a56cf4da8f9e06bd44e625135c6191a24031"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a09aab7cd11f62a9e3e470f29d84a56cf4da8f9e06bd44e625135c6191a24031"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a09aab7cd11f62a9e3e470f29d84a56cf4da8f9e06bd44e625135c6191a24031"
    sha256 cellar: :any_skip_relocation, ventura:        "72ff80bd0b8e51a4148493f383bb3b79881b2f441180e1d2d777f3ac163d8b28"
    sha256 cellar: :any_skip_relocation, monterey:       "72ff80bd0b8e51a4148493f383bb3b79881b2f441180e1d2d777f3ac163d8b28"
    sha256 cellar: :any_skip_relocation, big_sur:        "72ff80bd0b8e51a4148493f383bb3b79881b2f441180e1d2d777f3ac163d8b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3a8e526a1a62169087029c874ca61a315f54878b4d92806d8a44f152dbb8c1e"
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