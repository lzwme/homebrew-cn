require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.22.0.tgz"
  sha256 "d2fdfc644300b103561c166cdcd22f0e7cb8fe046b40055a5e10f8e8e6eb3d3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1741f1bcc6de65a16ab9f59f5bf89795682e3dfef2836d69bae1b29e14aeb5ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1741f1bcc6de65a16ab9f59f5bf89795682e3dfef2836d69bae1b29e14aeb5ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1741f1bcc6de65a16ab9f59f5bf89795682e3dfef2836d69bae1b29e14aeb5ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe4cad079b3d6c74799be0760928b06fb3a31eb2084b5ab874b59f44f276eb0c"
    sha256 cellar: :any_skip_relocation, ventura:        "fe4cad079b3d6c74799be0760928b06fb3a31eb2084b5ab874b59f44f276eb0c"
    sha256 cellar: :any_skip_relocation, monterey:       "fe4cad079b3d6c74799be0760928b06fb3a31eb2084b5ab874b59f44f276eb0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec3bdd3a2e748f00d7999af10cd06ec763037f1407d572939f3f4bd2ebe4c161"
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