require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.5.tgz"
  sha256 "04cb6c5c9c67f6911bd60f4f363bbab4423251b601c61e8b1737ea4ede5e942d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ddcf55de2adbccd0be132fe5d99038b064d8505078d4d0605cc990c1cee7595"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ddcf55de2adbccd0be132fe5d99038b064d8505078d4d0605cc990c1cee7595"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ddcf55de2adbccd0be132fe5d99038b064d8505078d4d0605cc990c1cee7595"
    sha256 cellar: :any_skip_relocation, ventura:        "a8326a2d89bbe915e165d44435937c63671efe7f6d4bbc45a2261aa2d65022df"
    sha256 cellar: :any_skip_relocation, monterey:       "a8326a2d89bbe915e165d44435937c63671efe7f6d4bbc45a2261aa2d65022df"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8326a2d89bbe915e165d44435937c63671efe7f6d4bbc45a2261aa2d65022df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5795b19288ea770db1b761cb1664cd5ec875ae5520297fb9149ab545c2f336a5"
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