class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.0.13.tar.gz"
  sha256 "a7261e3b6067e3d7e35d3fc0df93f220d8ed9a8a1ef4d1d775690df225394162"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e42ff1e97320500df6182d7ac067c34d7bec7a31fd5ea242b6beb1ffefebf856"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86731e70fa0e8c6c1a77843124b0c70f569a92e9d81c226833697c255779f6a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f7da4dca2b7643918df1322cf46668c909135419ef4efad6127440c2d5bd5c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cec55aeba24b2198239664b4bfbf69a7a3335e3ae6e5cfa8236033009f477b8"
    sha256 cellar: :any_skip_relocation, ventura:        "2a7d49b8c19b3f38720d852f6d0068a2de408b45a002e7421367297aedf66764"
    sha256 cellar: :any_skip_relocation, monterey:       "8feb6a92677a246cd38d67b185ffc95df6281961cccb7cb934b354537694aa28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb7171ab033887468e0b12eb8572e0addd039607690267461701b7711d058a7d"
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