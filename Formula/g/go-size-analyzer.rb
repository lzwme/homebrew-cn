class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.0.11.tar.gz"
  sha256 "a45a2573f2e8b9cdac1232d758d13303fa214d806bfa2c3ea3a0a634576504cb"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6808f7286ca19acf28bbeefa2d1f475208b3f4496d026f411033956d77fe0566"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e7f752152bf30ec4e05b45d23ef34f7e25ca3cf4ba5ef3ead26a7176a4aee65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f804b57352e256d9664d9c12f08c845d0892dd21a07f98cf90d96cabeddf19d"
    sha256 cellar: :any_skip_relocation, sonoma:         "71dd830217ca742a63f5ccbfe27a8ce6fafef54d0cc14755c7c532c194a2d477"
    sha256 cellar: :any_skip_relocation, ventura:        "f0e0fb6d0c14c34e34cd9de0a0f0222080b61939b8c10d3c226cee5444bbabc0"
    sha256 cellar: :any_skip_relocation, monterey:       "4061f8d08dcfcea2d2f96498bc803688636e8d29b46906fe3b20474f117ebc95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3711bbdfafec5d9d0afa718c72bda74a0894782a7c9a49e7fdca49849d1c762"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "build"

    mv "uidistindex.html", "internalwebuiindex.html"

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