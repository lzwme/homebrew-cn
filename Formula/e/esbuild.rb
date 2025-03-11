class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https:esbuild.github.io"
  url "https:github.comevanwesbuildarchiverefstagsv0.25.1.tar.gz"
  sha256 "5e84e44d7d2c2751f0b67e8cf909def3b0189b8e9549bcd663cadab582ab2947"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09dfe66cbcefe6080f5c063e239f4c4e8131391fc0d3b772a199c4295ed4d41c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09dfe66cbcefe6080f5c063e239f4c4e8131391fc0d3b772a199c4295ed4d41c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09dfe66cbcefe6080f5c063e239f4c4e8131391fc0d3b772a199c4295ed4d41c"
    sha256 cellar: :any_skip_relocation, sonoma:        "85cba96764f545dd9dfd101cc45d25619b953594ac1b4d1aa255a17ed5f3801c"
    sha256 cellar: :any_skip_relocation, ventura:       "85cba96764f545dd9dfd101cc45d25619b953594ac1b4d1aa255a17ed5f3801c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5f76bb808ab1be6e20ebc211cd88d3597444818c5eb22d7ec50be2c8c413c12"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdesbuild"
  end

  test do
    (testpath"app.jsx").write <<~JS
      import * as React from 'react'
      import * as Server from 'react-domserver'

      let Greet = () => <h1>Hello, world!<h1>
      console.log(Server.renderToString(<Greet >))
      process.exit()
    JS

    system Formula["node"].libexec"binnpm", "install", "react", "react-dom"
    system bin"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!<h1>\n", shell_output("node out.js")
  end
end