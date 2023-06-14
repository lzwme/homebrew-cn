require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.2.tgz"
  sha256 "80c624c6435773efc5ffe9502840d4b2da2a3f13b0749f93c301399ce376431b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ea08cecd7a9f7cb9bed2033e5ff1a0c4bd750e7c917fd5fde6704a16ebd65fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ea08cecd7a9f7cb9bed2033e5ff1a0c4bd750e7c917fd5fde6704a16ebd65fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ea08cecd7a9f7cb9bed2033e5ff1a0c4bd750e7c917fd5fde6704a16ebd65fa"
    sha256 cellar: :any_skip_relocation, ventura:        "0143fea1947c2a493ef8c826cb3a371814882b5ee6ba4c3a2b6cf20fe0e5cb12"
    sha256 cellar: :any_skip_relocation, monterey:       "0143fea1947c2a493ef8c826cb3a371814882b5ee6ba4c3a2b6cf20fe0e5cb12"
    sha256 cellar: :any_skip_relocation, big_sur:        "0143fea1947c2a493ef8c826cb3a371814882b5ee6ba4c3a2b6cf20fe0e5cb12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb5d64f0518c8a615b0a954aa56b13fd2867b467615528f63c6ced0e62bac14"
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