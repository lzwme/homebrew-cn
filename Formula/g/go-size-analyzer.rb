class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.7.0.tar.gz"
  sha256 "0ecd0f4ca84101374e3847b5e5e9e9c2a2ea53f857172b9641fe183519076eb3"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f69f8c88b016ff5c8dbd2eb115d602e3f8ea5296946f578cf0ebc30aee17aa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5c50eca26f8bccdc1eefe115f3e530429e2a91dda232ac140dbd2baa19130df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac9b029d47e3ab5cab3dcefdca22bc0cb8a2d4298e6ae244b42b040c7078d745"
    sha256 cellar: :any_skip_relocation, sonoma:         "b315cd72b23c428e5caff7896ee0c1072387870b1fdc96372d81f4d46b0ac052"
    sha256 cellar: :any_skip_relocation, ventura:        "e4869c6916c476ed53a6a7305e8b3707c42db4c66b13b7fdb9bf4eed7c2f6bf1"
    sha256 cellar: :any_skip_relocation, monterey:       "8d6c03aaabc3f530cbbaab122e2aa109948c1ac35f488ef67a3b4616a956c580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "324aac91a9cc4eb35f711c27d0423674acd065a45757b19f98c12a4162bd4aae"
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
    assert_match version.to_s, shell_output("#{bin}gsa --version")
    assert_match "Usage", shell_output("#{bin}gsa invalid 2>&1", 1)

    (testpath"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    EOS

    system "go", "build", testpath"hello.go"

    output = shell_output("#{bin}gsa #{testpath}hello 2>&1")
    assert_match "runtime", output
    assert_match "main", output
  end
end