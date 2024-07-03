require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.23.0.tgz"
  sha256 "1ba7823555e8960f2f2fac0b6656840f8de88c2237c00cb666229a887dc81fa7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12311234421be478115e187c9013f91ccc8bb12145c3f7dc92c46d89e2bad6d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12311234421be478115e187c9013f91ccc8bb12145c3f7dc92c46d89e2bad6d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12311234421be478115e187c9013f91ccc8bb12145c3f7dc92c46d89e2bad6d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "46fd5d8cdf17a57939e8b72cfbdc2df4c73d21cca0666b7ded387d7a5b9429be"
    sha256 cellar: :any_skip_relocation, ventura:        "46fd5d8cdf17a57939e8b72cfbdc2df4c73d21cca0666b7ded387d7a5b9429be"
    sha256 cellar: :any_skip_relocation, monterey:       "46fd5d8cdf17a57939e8b72cfbdc2df4c73d21cca0666b7ded387d7a5b9429be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5ea30dc768145e289400d5e95ef9cfd467641b9ce06781334cda6360d59969"
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