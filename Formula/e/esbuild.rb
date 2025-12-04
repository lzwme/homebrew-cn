class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://ghfast.top/https://github.com/evanw/esbuild/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "bcc3abdc911961ef04340714dc69ddc34af6d2e2c60a1c4036d1c7f1a3fc4a23"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11d13b1e699e464906638a3cd03e64ca869d1b4638f0fadbdadbfb01dae739bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11d13b1e699e464906638a3cd03e64ca869d1b4638f0fadbdadbfb01dae739bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11d13b1e699e464906638a3cd03e64ca869d1b4638f0fadbdadbfb01dae739bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d77af2de3e7d731f3e1d0254af7bc27ace0b6fb63b8de53c6ba93d9efc9a49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2217245628968ed89b489562617d9ccf2433654276c6bf5565298f11c0eb095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ff4dec8ff9f88b0d90dd07118ecb056ae9a8b73250e89e399eadd9a21b6001d"
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