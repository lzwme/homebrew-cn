require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.12.tgz"
  sha256 "a9ad9ecbcf189ff039b58a4869a9c2f3e720840f0d98d25149be0ad3765c6731"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13e403e837d0f8eac63a7ad9ce8c2fe4e5f670e3d607f019799157be3aa797bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13e403e837d0f8eac63a7ad9ce8c2fe4e5f670e3d607f019799157be3aa797bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13e403e837d0f8eac63a7ad9ce8c2fe4e5f670e3d607f019799157be3aa797bf"
    sha256 cellar: :any_skip_relocation, ventura:        "08296e425c4efce82018f346cafa182fe67595c2bc7f82e31b64202124f3f160"
    sha256 cellar: :any_skip_relocation, monterey:       "08296e425c4efce82018f346cafa182fe67595c2bc7f82e31b64202124f3f160"
    sha256 cellar: :any_skip_relocation, big_sur:        "08296e425c4efce82018f346cafa182fe67595c2bc7f82e31b64202124f3f160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d95c7acd3e355c7db79ee310a88573908ec0b16185bba04c1335ff6c906f74"
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