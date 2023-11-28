require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.8.tgz"
  sha256 "9fac1a7f5a014ea26e1719b48f58f27d36d8edf1d36376bf86253e8977939f81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88e4369c6ec51f4f38f83e98ff71511b52f9c74dcb5770906ff3ea222a1d35f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88e4369c6ec51f4f38f83e98ff71511b52f9c74dcb5770906ff3ea222a1d35f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88e4369c6ec51f4f38f83e98ff71511b52f9c74dcb5770906ff3ea222a1d35f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b347c9f5bbaa5ff2c41a108197b4216ab711b8170209c121ae05de887e5e6100"
    sha256 cellar: :any_skip_relocation, ventura:        "b347c9f5bbaa5ff2c41a108197b4216ab711b8170209c121ae05de887e5e6100"
    sha256 cellar: :any_skip_relocation, monterey:       "b347c9f5bbaa5ff2c41a108197b4216ab711b8170209c121ae05de887e5e6100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27d624eb9e614b8b32364393f1d8860432e0a70d6a92d20556f5088ecc1162fd"
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