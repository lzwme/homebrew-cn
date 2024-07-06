class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.4.0.tar.gz"
  sha256 "082da5c90f08db80ffcbbce07456d5cc0ce2e86c62abb78fd74f2f4cdeccd583"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e62e9503c505da8417d8befb7553521f0451ce15e30290787ced4bf1617a12c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e46399662c0c8db09225b1bf9023a0862f99a7d49043895fdafee8d2950713e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63a4b89e72e8e12342de8d5eded9fb539111b0cfd5ad5c2f85255a742f8133dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "1191aba393328e3df97a3d4b4206c469d504ffa9f092f88be1b70ca47caedaf3"
    sha256 cellar: :any_skip_relocation, ventura:        "a917c642dbd97d6cc0ee8138603648f08686028b82c73036dba4fbf13bf3cc5b"
    sha256 cellar: :any_skip_relocation, monterey:       "c95df8f663264b3a6fa7cb33b4a1e8f3a70f3890c00ed7b770cc5f548a450865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f009ce35cf1fe1742f9908042fbc1d944de625c1484a404e92ef57afa9bf94"
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