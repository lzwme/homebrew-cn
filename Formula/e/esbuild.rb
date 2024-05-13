require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.21.2.tgz"
  sha256 "1e13138442a943683c7f489c52ad19df29e37e002ddcc75686542294a585fe68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3e85ab5bc905b9009b8ae17a485de059773ed0936eaf40842ffd1ccf2c66e08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df2385b2cb412c262c997a8c977d9014c4e56db20400ff37b6f25a48cdba9304"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "614d7a613520e314228d00006ad261a8631c688e0e7e21d2e330839620946f37"
    sha256 cellar: :any_skip_relocation, sonoma:         "c59308123dc5a1f34f49c74a616ef45626a11b946d8da21348a13ec885cc9f5d"
    sha256 cellar: :any_skip_relocation, ventura:        "8f481a2983fdb0996c3b5b1f3c804aefc0583c33a3fc99b7e1a0134396fff1eb"
    sha256 cellar: :any_skip_relocation, monterey:       "501fae30c8e3b778b57e585c43a6d56780e0cfc655bed28b70e2e9eb2ead9a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc07b1fed3b9dd661c6e2821f0ae388a41ef80c2839a71eaa6f96170dc0bf068"
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