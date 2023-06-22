require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.6.tgz"
  sha256 "9527c79df08f8ad6f624372f6c74a09bd2518838528e777149fb18bf2b66ddf8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "783cbaae49be02105fee54fc74fb170f612b61826ae92e951bac934299196487"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "783cbaae49be02105fee54fc74fb170f612b61826ae92e951bac934299196487"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "783cbaae49be02105fee54fc74fb170f612b61826ae92e951bac934299196487"
    sha256 cellar: :any_skip_relocation, ventura:        "3f4c994388ad6b354d4886871b3634f84091ed96d72aea821bf0ea32fcb2177d"
    sha256 cellar: :any_skip_relocation, monterey:       "3f4c994388ad6b354d4886871b3634f84091ed96d72aea821bf0ea32fcb2177d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f4c994388ad6b354d4886871b3634f84091ed96d72aea821bf0ea32fcb2177d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "566443d83f612771858d33372cf235b44c558335a128feb1af522ebdd1a29068"
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