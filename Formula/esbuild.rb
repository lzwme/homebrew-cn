require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.14.tgz"
  sha256 "5693b32dd979ad221f24cec7046fed365af78c02917a4bf78c9d495238b043ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7854c96db31305467b05692b8eadb6864ff81a4cb1d8759869674cc442c42a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7854c96db31305467b05692b8eadb6864ff81a4cb1d8759869674cc442c42a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7854c96db31305467b05692b8eadb6864ff81a4cb1d8759869674cc442c42a6"
    sha256 cellar: :any_skip_relocation, ventura:        "e278bab0d20862022d01d0eca348b6d209da3c0fc036843b9dd1c69d62f58f89"
    sha256 cellar: :any_skip_relocation, monterey:       "e278bab0d20862022d01d0eca348b6d209da3c0fc036843b9dd1c69d62f58f89"
    sha256 cellar: :any_skip_relocation, big_sur:        "e278bab0d20862022d01d0eca348b6d209da3c0fc036843b9dd1c69d62f58f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f00dd95ef32bba15a71a7afad3d278997cf44c8f0ff32c558cf3cea3de0920a"
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