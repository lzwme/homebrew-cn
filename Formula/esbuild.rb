require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.13.tgz"
  sha256 "39cd8bf47ad5d716c862417b391213baa706997101fab4be56ecd787e6a6bdac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dbba6d5ebde00e0c446b4875db42d030af159986af0e6bf197003e704e9692d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dbba6d5ebde00e0c446b4875db42d030af159986af0e6bf197003e704e9692d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dbba6d5ebde00e0c446b4875db42d030af159986af0e6bf197003e704e9692d"
    sha256 cellar: :any_skip_relocation, ventura:        "c4f5d9c8322008b97e2becebc656140077149f61a30e4059f882cd8259c7d173"
    sha256 cellar: :any_skip_relocation, monterey:       "c4f5d9c8322008b97e2becebc656140077149f61a30e4059f882cd8259c7d173"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4f5d9c8322008b97e2becebc656140077149f61a30e4059f882cd8259c7d173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3ccc6b0d435ef33e7e7842534079f358d1cd1788485e5d0e9f87ff1d4bac61d"
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