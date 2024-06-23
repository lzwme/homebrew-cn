class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.8.tar.gz"
  sha256 "4bc9d1d21c5d929b73bd558d2a3bafee95a230d7ea39eeaf3abf62d9f6c02aa5"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffe64b15767b51e4c0c89a53c64af5ebfac183fba5e8eb3fc20220d39d01474b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fed65be2c22a55e2bb10e5c84a443fa79bf9c260de49814601ec98bacc9fba89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39008aae0f063f68d2259c5d5bd8b4b3fc2f8ac3a11371ea919f9e3e18ff1a49"
    sha256 cellar: :any_skip_relocation, sonoma:         "666ddaa95bf1304c284757ec1f7bbe39b53a70dfc99d71b1494140bcf535d7b4"
    sha256 cellar: :any_skip_relocation, ventura:        "e30ea84abb753d32d673a5b43820695b4ec7723918fd43f0644f379cd67490b1"
    sha256 cellar: :any_skip_relocation, monterey:       "a6aacd6bf060a9158441df53a236c8c4005aae28589b6659335ae3c7aa0520ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d841afed51ba319cf044ef57ab455a929630fc539d3c8a58abc50f2f4383ee3"
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