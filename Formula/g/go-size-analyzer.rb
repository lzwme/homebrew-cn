class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.5.0.tar.gz"
  sha256 "94b658d94c415b0e1d29b74d67cfa2a0ca2cbf452aa4251afc09fd24f9b04bd1"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf8dd704d93b1ab76d839893f2bfff82c73ce0e7d4f422b858907c679952ef15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbf2d08864a4b3aab7dd1d580c18898c2adeef36ce70808e7e42b3b92e91d6ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9ee6ebf3b2ffb5374f0c27f0eb6ef4c05b48da57e4ff65489fe5059dd046e8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "140589d809a0879557a0fe4aae81b743d199782f40397ae523387d5e0ef2197c"
    sha256 cellar: :any_skip_relocation, ventura:        "a28bc511ccf9bd58ae6ce6d97b101511b2078cf530ef5446ececfbfea6679703"
    sha256 cellar: :any_skip_relocation, monterey:       "e2ba760c05406e8dfd255e07abab6c92829739fb18277f336ddc6035b6662da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1508a6f331ee7e8909c0d4361af370f450ea23a4c9ecaebf14bc2c15c307722c"
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