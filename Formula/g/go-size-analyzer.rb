class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.3.tar.gz"
  sha256 "1b1aa80ca4b80678082d284c6efa963d776a0cdae93a05cc8e935d6173357056"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5129c12b8efd6eaf5e02ea54346681aa25b67be085f894ee646c71e9cf8319f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ade661d3b1668606c30e8259d6cc17bafe8973ae4a2f4ecbc0a018a6b695e30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cf54126ebbe7c02aa2c8b819602e89c1136ecc72f2aa0c1f45e060f5e56c113"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbc241446eae2b366297a228b6968773ff51149c76bed43c5d5b9f54950c9a1e"
    sha256 cellar: :any_skip_relocation, ventura:        "6acd2e0681e9b780db0e6539312cf8166bfa5582a9d2bf29ab7231bd2a5a6cfc"
    sha256 cellar: :any_skip_relocation, monterey:       "8b5b7367eddb0b4418dc53c7c84046b9eb1ae6b6833048efbd8369d30cde08a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eae3775de15a66bb2d4d778d67af24bba25dbb4a0175ee65d826e4a1bb29d91e"
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