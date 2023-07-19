require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.14.tgz"
  sha256 "71a0df331d53a66a90c30a872c58e76c71904b43be67716af4fd9b9056c17008"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f892d7b621c0192224b6252c70ac26b146f2529a466b7428d6de9317d69b433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f892d7b621c0192224b6252c70ac26b146f2529a466b7428d6de9317d69b433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f892d7b621c0192224b6252c70ac26b146f2529a466b7428d6de9317d69b433"
    sha256 cellar: :any_skip_relocation, ventura:        "b9f50a5d30a6ffef604ee55e654e6a6f8ec13d0af16d2365ddd00f68dee58c44"
    sha256 cellar: :any_skip_relocation, monterey:       "b9f50a5d30a6ffef604ee55e654e6a6f8ec13d0af16d2365ddd00f68dee58c44"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9f50a5d30a6ffef604ee55e654e6a6f8ec13d0af16d2365ddd00f68dee58c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "befc2269453bba236affc26ddf8981e31f04244e8bf742c10d65dff89766964e"
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