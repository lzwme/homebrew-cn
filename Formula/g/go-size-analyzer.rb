class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.11.tar.gz"
  sha256 "ad455f7e9e118d8b08b94138f1831f0c95696ea956275ea0b398e79e7960f100"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "280ae0455c1c3479fe9513134da08d96cb06106cb8e6a044c0c9bb32cd39fcf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "631de2af8f9928ca85d38aa4279d262b5491d22d3c8be0fa430a7aeed0713f52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcb0be7b8e4883e4b9d15a4e2efffe7823080a329b994e9658e7cb237547bdd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1a54c6b63d2c69f0b99b0309b177a2d79a9f6c7909ff470314ed9fdd1aecc55"
    sha256 cellar: :any_skip_relocation, ventura:        "f16ed57005a5c2dba3edc47241f2e4812fff0b98df4b2edc91eb79f6adb6566b"
    sha256 cellar: :any_skip_relocation, monterey:       "bfcd0fb0087a837c183f7c3e23de304b11a719e9e769cf57172c6b37a03a2dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04f1b17aa32820ae3b4932cf9be53c9982ea116e8d6f3871400ccee1ec21f22f"
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