class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.5.tar.gz"
  sha256 "e70cb1b246e637923485badc0f5450d9d760fbd28f9bb4e111f880234273c955"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c774add98939196f7b6873f20ffe81352080adf6e69d7ab405dc652ea8b470b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27601b1b7121c83f56471106c1aa503cf0be55d1fb76b6bac0f725ecd916b33c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36232834fbe67e8c68d52fb56b96e74c0804a913c8d751d6983174f5b30952f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "05013587cdb4d2cae1f1d22c507c1c22615a56d95943919ce3ceaba036471b5a"
    sha256 cellar: :any_skip_relocation, ventura:        "aad0bfeb6065a8aef7ca66c56e8360f635f657b6a93ff4e21ea5c25444a0b7a5"
    sha256 cellar: :any_skip_relocation, monterey:       "7d9277207f670ef40bac9c44970f46cd9846e134dda3f95193bae782adf5f2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54a528e0fb506f4c482ab6ddd9ea8d0d1a9583846bf2b27a4d159ce1514f279"
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