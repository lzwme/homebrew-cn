class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://ghfast.top/https://github.com/evanw/esbuild/archive/refs/tags/v0.25.11.tar.gz"
  sha256 "7f740feb86a0e5803ecb1ded40d4bb4ce7c1ad1bd571e7f62adfbbec45cc5d54"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e58a6afb5b16cace80b3b6017fadee99a7561eaca1635caf2047c7948431966"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e58a6afb5b16cace80b3b6017fadee99a7561eaca1635caf2047c7948431966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e58a6afb5b16cace80b3b6017fadee99a7561eaca1635caf2047c7948431966"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c7f3ee36239e0e2625cd7ba4090ee972381857008aeee7ae731d63161e2fc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d510949c2b91455fd36dc5daa081aef95161f7079c1654757ba0982432203a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "685d5fc7b737c5d8202f3cf138ff3df2c9a7df3598f420b65b89c55976fe8d6c"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/esbuild"
  end

  test do
    (testpath/"app.jsx").write <<~JS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
      process.exit()
    JS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end