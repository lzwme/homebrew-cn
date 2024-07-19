class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.5.1.tar.gz"
  sha256 "bef2529772da5070aedc7fedebcf1edd29c713cf1d78b55e9cd79edd08922e29"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7915a88740abd585dfe62adb7772e4278b06d3cc21e654ecb2c8974f9406e32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "186ab34f66b20d47ae3108511459ae5b0b6544dd21c477632730cd388a5de05b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb5d2f804c531e7e199555bee13fd91f4734509c9aa83f95ce4cf0b34ce7c2d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2527e282b63cf0f5cfebe44f61f523620594ec2ec8fa26fe14e88e3701d421d7"
    sha256 cellar: :any_skip_relocation, ventura:        "8e8ca724d81fe061ff20e9bb923e8d00663391b700b7f3cf08ba884dd1af6708"
    sha256 cellar: :any_skip_relocation, monterey:       "b28a410fbc788827c5f8228f8893c196739463edd35b97e938f6330bf9211fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c31ddc2ea29cfeca37a8ed6e10aba2b35d4324f55b43e53867ed3a94509a14fd"
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