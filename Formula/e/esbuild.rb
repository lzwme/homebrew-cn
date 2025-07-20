class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://ghfast.top/https://github.com/evanw/esbuild/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "d2a20b2644261154819846f42acfe270d26caa77be05431a3b00a1122941a662"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa0f932ee66847e49e13d09eebe365a3df06aac15b7a2d904544fd41803d4131"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa0f932ee66847e49e13d09eebe365a3df06aac15b7a2d904544fd41803d4131"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa0f932ee66847e49e13d09eebe365a3df06aac15b7a2d904544fd41803d4131"
    sha256 cellar: :any_skip_relocation, sonoma:        "e15bcfd6af93e17a8ba25da495a7bfdce52605be4f8f7f526e6ea2911ac4e831"
    sha256 cellar: :any_skip_relocation, ventura:       "e15bcfd6af93e17a8ba25da495a7bfdce52605be4f8f7f526e6ea2911ac4e831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024fed9185551d49c6fb6df823ce6fef177d610d44dafbdc9aa31d7362782a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d070dbdaec9a6490d7ba58dd8a04554a7696ae42a6a1ee809c4a5e4b8147d0"
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