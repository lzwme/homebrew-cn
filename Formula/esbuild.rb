require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.16.tgz"
  sha256 "e0cfe7e5a12c19df8902a6bba70fb8032f85b7dfdc9d900e1031b2b5a7249d28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37cd66e9de5d0dc6a24002057fa16c435ecc9e46a3bd8db7f3eec612d21f0a6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37cd66e9de5d0dc6a24002057fa16c435ecc9e46a3bd8db7f3eec612d21f0a6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37cd66e9de5d0dc6a24002057fa16c435ecc9e46a3bd8db7f3eec612d21f0a6b"
    sha256 cellar: :any_skip_relocation, ventura:        "c5b9a9c487c6c1a2c5252ac3a52182cec626e290d9180d4409020d1d56859d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "c5b9a9c487c6c1a2c5252ac3a52182cec626e290d9180d4409020d1d56859d9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5b9a9c487c6c1a2c5252ac3a52182cec626e290d9180d4409020d1d56859d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd72adf38e3ee0cb94ea242e590a023739d4bc6cd0aa04b150eae244fca19e8f"
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