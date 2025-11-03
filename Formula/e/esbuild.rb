class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://ghfast.top/https://github.com/evanw/esbuild/archive/refs/tags/v0.25.12.tar.gz"
  sha256 "eca56e4242e68ebde6f327458c71457e614a2b0564b30a45d60fc633e0ccaab4"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "391728480982b4479bda80aa09525847c597261c76ce9c0f0c310ea6d5489dca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391728480982b4479bda80aa09525847c597261c76ce9c0f0c310ea6d5489dca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391728480982b4479bda80aa09525847c597261c76ce9c0f0c310ea6d5489dca"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be0648d2c14eeea26fdffa81f1be0536cbc7d55d5c78eab9e87d4022d53fd7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2689eba2a8f679b6f5b90305ddc51e2290fbf91b37a2e01477b2999434a15950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d27cf80260baa6b09225678c5de85909dd905d04c374562cd20afb83189927a"
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