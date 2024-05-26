require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.21.4.tgz"
  sha256 "a025d26323a8ae7d61a9dd6421c308b837ea9dba806034160f153a617d2f2bd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c1920c3f5d6146dfa17fe7d5c154e894b13bd99a0502ba2606c0b999019cdb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97c079eb07a61186fd254de2a40f5432257116ea5f9ccba7484a768054442dc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b644992ce936dabe585fdf91064b55ec1107653c9d772e82554836e5aba46bef"
    sha256 cellar: :any_skip_relocation, sonoma:         "e33eeb78c4558d4dec4ea3642d6cc4bce5c3d35a3bcc4cb0ddb6b6581a00fa4e"
    sha256 cellar: :any_skip_relocation, ventura:        "ad7c6a66288f7493744f48218e8f3e097b5f169953a802b008a2df94da724c49"
    sha256 cellar: :any_skip_relocation, monterey:       "8236b60ee68cee829f2b8e5da5493c851587270743143996e3b55d53aadf76b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bc47b526dc6950addfcec44d1c772369de8e7e9d94bf1ea495db729d3cc2b69"
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