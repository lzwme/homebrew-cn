class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://ghfast.top/https://github.com/evanw/esbuild/archive/refs/tags/v0.25.9.tar.gz"
  sha256 "ae3401455b241827800299aba368683db0042044eb7ed8e43ca0180c85531da4"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6c8af59a81717233cccab20767bc1665e354107de6f608626a7569d01a3496c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6c8af59a81717233cccab20767bc1665e354107de6f608626a7569d01a3496c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6c8af59a81717233cccab20767bc1665e354107de6f608626a7569d01a3496c"
    sha256 cellar: :any_skip_relocation, sonoma:        "957fcb81268633954881c63421cc7df8af3e86775345fc2eed860d252eccdd1c"
    sha256 cellar: :any_skip_relocation, ventura:       "957fcb81268633954881c63421cc7df8af3e86775345fc2eed860d252eccdd1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da380609ddbaba3c97eb20e401360848aee81710f7118b581cc99b9474cf0f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b9c983eb15533550fd853ada90c7db3b2c0b5070fcd930da33e20b6df0bdbe5"
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