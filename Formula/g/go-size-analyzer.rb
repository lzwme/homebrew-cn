class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.4.1.tar.gz"
  sha256 "3e19b96f5c5289d03a8c7da5b1fe1f74dca34e605a9d342af796a5e88cd1fcd6"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8acfaea12d6ed45e362783ee4e065e1a4b2f822bf7998ec9632405d5f41d081"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "153d679e6546a70743a980d7050449a298b45596837b54ab632d3975e5c565e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcace40e6720b2e4e986ed546c1a6dfcfa3a805bd696779771781aa4f32af497"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bc6721adfc9ba6e100c5ce95a0484e61686509e48695686ba4245e32ab520bd"
    sha256 cellar: :any_skip_relocation, ventura:        "6d77a07ad51f1aff9ce75a457f9535715e033cffa93d64b943eb1dbf6166d1af"
    sha256 cellar: :any_skip_relocation, monterey:       "b9ce9c432ede63c4303039592524860a5e80ad24b7ddfbee77eb7db3348bebcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd1aabc358c2396e6a57e5f04442298741a38447086309882ceff4c3e45a0ecb"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  conflicts_with "gwenhywfar", because: "both install `gsa` binaries"

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