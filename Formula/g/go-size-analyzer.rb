class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.10.tar.gz"
  sha256 "96313d7255316dc12ca2d37a78a6eedab9ec2e55df7347dd4c28f47fa49d4830"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "762511c667980908b9e7cb1fa6a64ebeabd3e0283d118035cb0a118f39dc568b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "567c05e5bad3624e39f6decdd31cca3fa3fc24be63aaab6d8ddf46bb4fb9b07e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d6c4362a8f4642a67b840537fc12de235c5f49bc2d5c54b6eb09b3727a3fac"
    sha256 cellar: :any_skip_relocation, sonoma:         "291de3eea1f60449bc26a9319e95a591e8b9c3e60914e6e0da1badfcca34b1f8"
    sha256 cellar: :any_skip_relocation, ventura:        "c29990623e630d91f6e7768dd87ee9feba2c38eda5ec7c09f3d7f0bb10539eac"
    sha256 cellar: :any_skip_relocation, monterey:       "745ebcacbea6d35d448af844f9376972a41ed0b888fa4ee2be3f197465e7f4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a662d607553956f5910c94f9198a82d97980351cd2342643cf83146bd5a1afc"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "build:ui"

    mv "uidistwebuiindex.html", "internalwebuiindex.html"

    ldflags = %W[
      -s -w
      -X github.comZxillygo-size-analyzer.version=#{version}
      -X github.comZxillygo-size-analyzer.buildDate=#{Time.now.iso8601}
      -X github.comZxillygo-size-analyzer.dirtyBuild=false
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"gsa"), "-tags", "embed", ".cmdgsa"
  end

  test do
    assert_includes shell_output("#{bin}gsa --version"), version

    assert_includes shell_output("#{bin}gsa invalid", 1), "Usage"

    (testpath"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    EOS

    system "go", "build", "-o", testpath"hello", testpath"hello.go"

    output = shell_output("#{bin}gsa #{testpath}hello 2>&1")

    assert_includes output, "runtime"
    assert_includes output, "main"
  end
end