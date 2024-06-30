class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.13.tar.gz"
  sha256 "7b80d3641b4213bbcfc8b3c7e88a2392bf6af1271c8449ef457c963ecba034cf"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b1c8fba06f11f82bc6f5db52f50fccf354dab00a3705474ba1241a4285473ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "623b6456bd737f8bc159a06b41cdf5b81e723190c3b1a90ee9734843ac982b4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2db1f95964ec15617181360f7104d6a79d6b6d4fcaebfffa46bb25285423124"
    sha256 cellar: :any_skip_relocation, sonoma:         "39651f499247600acf5ca6cf2f59af94d8ba8aa246f305ffd4cd9703267421dd"
    sha256 cellar: :any_skip_relocation, ventura:        "a4b0eb05922097574c5c19216070deb745ccd0e0a215e50bf294155d4faf2efb"
    sha256 cellar: :any_skip_relocation, monterey:       "d5c9813cd01426fb11a034dea4998c0f25a96266faf52c9c602b61df6381b902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9412802cb2ff11793ee451aab361ec8ee633669fe44601a2dfdd0dfdc72c185"
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