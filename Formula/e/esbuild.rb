require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.12.tgz"
  sha256 "cdbd0cba6bd625d07f480f4cfa4105935c7ec606f52861862a93cfd255ea8fbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c11872f5a8b4e9a0bb7798d2c5a0707db75baf0e2119e1f75ad3ca1d75fc616d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c11872f5a8b4e9a0bb7798d2c5a0707db75baf0e2119e1f75ad3ca1d75fc616d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c11872f5a8b4e9a0bb7798d2c5a0707db75baf0e2119e1f75ad3ca1d75fc616d"
    sha256 cellar: :any_skip_relocation, sonoma:         "202cc837205b0985a7d8fccd15125e6d500add717a09d209ddc75d099d77b6ed"
    sha256 cellar: :any_skip_relocation, ventura:        "202cc837205b0985a7d8fccd15125e6d500add717a09d209ddc75d099d77b6ed"
    sha256 cellar: :any_skip_relocation, monterey:       "202cc837205b0985a7d8fccd15125e6d500add717a09d209ddc75d099d77b6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb152964ae3d0a2e99e5aaf0b8377f02b8d065743cc1fc6289ffe47dd4f2e9b8"
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