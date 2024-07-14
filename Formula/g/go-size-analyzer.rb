class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.4.3.tar.gz"
  sha256 "0598913ea4580e2b22df376c6f2021a01c4227cb44d70e1b3c6270d9d5f8f9cf"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99cbdc6663160d4cf0e69f6ed408b0086d1034b74f00fa80e3a8726649313635"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eb9534073b1527d6ff74654dc74166ca472f86ed4636509f8d951aa1e4eed58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73eb2f69f992e54f4a750df553bf0fa79fa0809ba35e074bd02c5d6c9e5414f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cbe54bed391a35d9ffd3795ea77b59520611dc2788add57c73d249197f9d1dd"
    sha256 cellar: :any_skip_relocation, ventura:        "8e822ba1b23f329e438c91ae6c692a38949443953b553b9408e4437c1151034f"
    sha256 cellar: :any_skip_relocation, monterey:       "4c27749952c9757f678f9df704e0a263d8d8d8516c0fddda255ce93585763260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9ea383fa12d81a2e9c78f9c58a84f628a30485ef96757457bc63afe5023f694"
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