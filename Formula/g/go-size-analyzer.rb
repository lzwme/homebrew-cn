class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.0.4.tar.gz"
  sha256 "c92ebee6298fc1c6b25e5ea2ed0324abd047ef0ac3dc80b110030562e93f89ae"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc6163b1d30f99e179ce5df5b2d0ed66c336ca4239aa2d747c62b3ca1b6c8cec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7158d22fe3789469589fbf04efad626e31b460773d2940c46ab3b9f9ca5cd55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4249641bcb1d1ad4f883a34bf21a4100ddaf3d8a8e021a909b760fee70c63f74"
    sha256 cellar: :any_skip_relocation, sonoma:         "30dd183466a8b332448e241fe61c9410b2523a77be5a509e9fdf5befaa054556"
    sha256 cellar: :any_skip_relocation, ventura:        "056f2f3485c02a396c7c6b71f387857e3fcabcbba5f5e932b5d212c5a89e4722"
    sha256 cellar: :any_skip_relocation, monterey:       "15bea7c7442db2454c539d1e0616dc7b41ac1217dff70736a15d16d408b0f6ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba49dfa0fef5ef8d07d87ec63b2887f66962a8e82d4a3efb291b47bd000e8087"
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