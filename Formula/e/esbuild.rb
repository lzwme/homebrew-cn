require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.7.tgz"
  sha256 "d40b9bb667a302c9d0b359f45b15326f5315d0ac9741a111f71bd6d93705c799"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5b5662c3a56470e43f97fbaff9bc28066bdf284c9f8797520acce1452a26721"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5b5662c3a56470e43f97fbaff9bc28066bdf284c9f8797520acce1452a26721"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5b5662c3a56470e43f97fbaff9bc28066bdf284c9f8797520acce1452a26721"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a00c115be1b54103622c69f5ac40cfaee19cfb23fee52b76630c29036271f76"
    sha256 cellar: :any_skip_relocation, ventura:        "5a00c115be1b54103622c69f5ac40cfaee19cfb23fee52b76630c29036271f76"
    sha256 cellar: :any_skip_relocation, monterey:       "5a00c115be1b54103622c69f5ac40cfaee19cfb23fee52b76630c29036271f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7092cea49ad71d29a2a85e841a6a7411a4ab6731593c89d5c90cd8fad379a2b"
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