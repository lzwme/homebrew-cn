class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.2.2.tar.gz"
  sha256 "0ac0b1c840a7ea4cdef36b6658530cd979eba353b5c2d7c07feea1474ae0003f"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "667b47717e5ba96ec0dedc9c7402e5b045d2a723d27eaf1d7362957a5b5a7e30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "449b3f0f28ce4173980a7c52b4aa251fe9ce174d66967313ac59a3310a9e660b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf989d18706ebde1888ac9e323400bce70164e1e030e663610e08f5ee9353d6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7255b0468a24a275034719e7badd2c117daff4df149049ba7141f6701ade05b2"
    sha256 cellar: :any_skip_relocation, ventura:        "e503ca65cefa3199f0662573416ca2172d14061a02dbe8d98b549bd4283f1bc9"
    sha256 cellar: :any_skip_relocation, monterey:       "97d036c8627cce75a4946e8216b735d8e9afc419a557099e10cac9865ca4154a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3e36805b62178fc16aa68a586a69a06115c91aaa4eb858aeb749d8fdf6b93c"
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