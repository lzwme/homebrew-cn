require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.4.tgz"
  sha256 "767a3fee2a7193011512ce51c215d467e75346280443f9db9edee07e17fb416a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96013ac086d3c7d03dbe66facc8ffe8e40478dafc79366df4f140f30b54d170f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96013ac086d3c7d03dbe66facc8ffe8e40478dafc79366df4f140f30b54d170f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96013ac086d3c7d03dbe66facc8ffe8e40478dafc79366df4f140f30b54d170f"
    sha256 cellar: :any_skip_relocation, sonoma:         "988e771a3b04cdcabd8f416e22d2bc23835a1546312359624551828b095ad7c2"
    sha256 cellar: :any_skip_relocation, ventura:        "988e771a3b04cdcabd8f416e22d2bc23835a1546312359624551828b095ad7c2"
    sha256 cellar: :any_skip_relocation, monterey:       "988e771a3b04cdcabd8f416e22d2bc23835a1546312359624551828b095ad7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ea8adc08903d0409f98131054baa27859d1dbb5b1e74d7c1847ffd616661c60"
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