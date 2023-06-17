require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.4.tgz"
  sha256 "bff3e24ee5461bc26bde27b8096b832a89bf44463eafa29fb06e104c4d9bedff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73cfe4bf9d247c6837f7437d0858c3d799edd9160ef1a5c4d4adc8f114c7d8c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73cfe4bf9d247c6837f7437d0858c3d799edd9160ef1a5c4d4adc8f114c7d8c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73cfe4bf9d247c6837f7437d0858c3d799edd9160ef1a5c4d4adc8f114c7d8c5"
    sha256 cellar: :any_skip_relocation, ventura:        "f93a0082bd485d378711780ba4f030e25dfbda0474e9ce9d0350b5aeabeb9b72"
    sha256 cellar: :any_skip_relocation, monterey:       "f93a0082bd485d378711780ba4f030e25dfbda0474e9ce9d0350b5aeabeb9b72"
    sha256 cellar: :any_skip_relocation, big_sur:        "f93a0082bd485d378711780ba4f030e25dfbda0474e9ce9d0350b5aeabeb9b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1202a441cc58ee97891fc2397bb6238c833477a8181a0eee1322f06fa4a829a"
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