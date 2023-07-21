require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.15.tgz"
  sha256 "982182b48ba9c45c692ff6b7bf3021d8969b1917a2da2f57bb0badae634b60af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b57538a695cc66b607741047d88b8b65aee86a6a012828c67cded7d7bb403583"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b57538a695cc66b607741047d88b8b65aee86a6a012828c67cded7d7bb403583"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b57538a695cc66b607741047d88b8b65aee86a6a012828c67cded7d7bb403583"
    sha256 cellar: :any_skip_relocation, ventura:        "9bc9396b6ba798e3b5fe6d490d6f7dab890f46f2c91531db6a7ed513dff80022"
    sha256 cellar: :any_skip_relocation, monterey:       "9bc9396b6ba798e3b5fe6d490d6f7dab890f46f2c91531db6a7ed513dff80022"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bc9396b6ba798e3b5fe6d490d6f7dab890f46f2c91531db6a7ed513dff80022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4368ba7dda9277e5f46b666aef764e6007b10e41aa67dd6a53bac2e7e5fbef"
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