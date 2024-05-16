require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.21.3.tgz"
  sha256 "bc1b7d50ea4a100ab81b50cd5cee2b2bc6b9d0511039aeefd976be2ef66367ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec21b7b5df5af6b604ab1baac6e78d321adda1244e6ad0b0d5da2c81ee70f9c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70eb7352f86901caf85cc7f86c1644387b6ecf6372a88b6042beb03f13d66bb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61b72772e3dd911f6cd48e69319fada0f1f8b25030a083d872e0ae44431db227"
    sha256 cellar: :any_skip_relocation, sonoma:         "19269d810e1bf38637934afe2bfd6e6a45df951731af940190849b1380c8ead1"
    sha256 cellar: :any_skip_relocation, ventura:        "a7cc50aa23e50fe393e09da7aa8441b85d211dcd936059c6ccc5e0d9c15f19a5"
    sha256 cellar: :any_skip_relocation, monterey:       "d06fa506b92531889adeb211cd5f16a8d98f93c08f2c591a5fffcacc00d47159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b92321c0db3bec383b7c3c4c3984b2ef090ca14c5232687bf33606160cb08e56"
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