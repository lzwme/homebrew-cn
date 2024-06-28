class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.12.tar.gz"
  sha256 "9392047f20b2ad65e8286f23c1cc390810eeda07c76ebc7813bb2ab1b1e702ab"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92cdce1e57fa1d7ceb15e4d76960601f736defa7d6d2beb785c8de9894f064e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3425653cb54770b9351d1189cfe2acee1c2221a60f8d6a3016c83afc56294e4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1e2cfa53bdfd2d93e0330db716f7528162a35775eebfec2337a9f78b90d943d"
    sha256 cellar: :any_skip_relocation, sonoma:         "adbb0f591836a936cb9aa80731c544251ac50fe560a60dc536d24168e563f9ce"
    sha256 cellar: :any_skip_relocation, ventura:        "7339f7eedb4dc655e9d81bf3a286c073ea38faa86f52807f52a6f19c249bef2e"
    sha256 cellar: :any_skip_relocation, monterey:       "24313d0f9620dbfe8ab8556ce1678c5ce7893b471eed5cad33d904af83bc74a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16eb266a1b6aa05c162974b17338d4dc88c1c83dfea1d19a22ede431c91ac98d"
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