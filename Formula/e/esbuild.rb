require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.10.tgz"
  sha256 "5a9752705943234f8c8ad098199759307cf722b88307128cef1c3c7464419114"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2386caaa3178748d1a4e6d890f83f004c173049b8aedb80a6fe6f5561d6d3575"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2386caaa3178748d1a4e6d890f83f004c173049b8aedb80a6fe6f5561d6d3575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2386caaa3178748d1a4e6d890f83f004c173049b8aedb80a6fe6f5561d6d3575"
    sha256 cellar: :any_skip_relocation, sonoma:         "b13f738d03cf2f7b47b407ddcd5585c0b402bf202a38ac392586a5227d378f28"
    sha256 cellar: :any_skip_relocation, ventura:        "b13f738d03cf2f7b47b407ddcd5585c0b402bf202a38ac392586a5227d378f28"
    sha256 cellar: :any_skip_relocation, monterey:       "b13f738d03cf2f7b47b407ddcd5585c0b402bf202a38ac392586a5227d378f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "404c8fb62048b79cc584544b0c98e8a7f8f6528a8d1b31de696930614b502b56"
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