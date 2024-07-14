class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https:esbuild.github.io"
  url "https:github.comevanwesbuildarchiverefstagsv0.23.0.tar.gz"
  sha256 "473d4d322ddc35f3620d37ecd5d6f40890f33923eeaafa96f5d87db9587e77af"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98279f532b870d25017a1fb370b308c179e25076a8a225ea5ec959428f111ce2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bbe6514b794d5f0e9aafdb4b7f08f418133273f4f1525f58b48d7e8604318b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada0cf2a33099a5fc4a010e7dfca8309454d8915a70d37b07d7f82982776013c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f0df1ef1dfd0fb24e8d274704535c5c43c72b6b3b6c49a6f10fbcb13200e922"
    sha256 cellar: :any_skip_relocation, ventura:        "7f6f1549786b26bdc2137bb6cabfb0b9e7ff8301abfc111a5bf256b33938548d"
    sha256 cellar: :any_skip_relocation, monterey:       "3cb9a7d924a11e2e3590a634aff74badc259f010dc9ea43bb3b6b6b7d9d39bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85aff4baa388f5404943c781633f79efbd2d28f37f928350beb356f2dc0599d6"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdesbuild"
  end

  test do
    (testpath"app.jsx").write <<~EOS
      import * as React from 'react'
      import * as Server from 'react-domserver'

      let Greet = () => <h1>Hello, world!<h1>
      console.log(Server.renderToString(<Greet >))
    EOS

    system Formula["node"].libexec"binnpm", "install", "react", "react-dom"
    system bin"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!<h1>\n", shell_output("node out.js")
  end
end