class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.0.6.tar.gz"
  sha256 "cb5365c81f3a605db09a87d6cc998c13a0da34806e3ed1bd2839786ec9cdfcec"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38306a69de32ffc552f228449fb59c14e6a53fec2147fb5222b5978928884801"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a51c70838f693ac345a5a9b50656c69099893018fc99704061b130df041c45fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d39fe1838af68d22be2d61a1808c9ca4a00e435c0ab5889b76b4a3fc5ac2f087"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3e9e0fb64d8f55511647b9d05b6d2399b7bcd5df8e30356a5d4a01dae65f01b"
    sha256 cellar: :any_skip_relocation, ventura:        "8e5dbaeecd586ababee83bf9917d197edd41d4aa670b955b1b2a6f6b13565f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "bb7dc6eb12f29017781909753d87c7e5b8cbf4d6d349d0e8988f6870f51ae8b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fda282fd589b3ca6bc78a49a3be6e360ca932160ec6f3709740e702fa2de31e3"
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

    output = shell_output("#{bin}gsa #{testpath}hello")

    assert_includes output, "runtime"
    assert_includes output, "main"
  end
end