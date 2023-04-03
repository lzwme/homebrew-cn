require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.15.tgz"
  sha256 "0c873c99f21f0b4b3b7f44f6a1772c5668d0215bb6ff6e27cacf58bb31ce9535"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "385dca23b591dad5fe8b20960ff12a2396f428b7eb44e816c53c5a4a2c639be2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "385dca23b591dad5fe8b20960ff12a2396f428b7eb44e816c53c5a4a2c639be2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "385dca23b591dad5fe8b20960ff12a2396f428b7eb44e816c53c5a4a2c639be2"
    sha256 cellar: :any_skip_relocation, ventura:        "fad1f9cd200d34eb76d8360f31f43d4d52b6a20ab912d3ce2c8b90303f560113"
    sha256 cellar: :any_skip_relocation, monterey:       "fad1f9cd200d34eb76d8360f31f43d4d52b6a20ab912d3ce2c8b90303f560113"
    sha256 cellar: :any_skip_relocation, big_sur:        "fad1f9cd200d34eb76d8360f31f43d4d52b6a20ab912d3ce2c8b90303f560113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a5defc3dc15e64fe83ecedcd69bf83b7f236d7a1f75b0b5f0c8909c67ce343"
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