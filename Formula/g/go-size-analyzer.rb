class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.2.3.tar.gz"
  sha256 "88c9eba29c864d0e8ac032747c893ccf9425c6512144422151652c693e4981a9"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b0359c63d1267212d6ba634765cce6a60076c227130760b4953e7c3c2942e8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "027d669ac4b1122abd7ed40d17a6437695ba5dd8e4a394fdad068e630376a4dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9cc803cc89a23ff310ec153a202c67d56a4813450ffe42c9121eed02cc42701"
    sha256 cellar: :any_skip_relocation, sonoma:         "a345fb22e69ee9f9ee00d8bce86100ed44a4a4ecea40c86fdf510e064848c2dc"
    sha256 cellar: :any_skip_relocation, ventura:        "7a38f43f1bb7f08b4dc2c821f42b03759f72394b72b2a98cd4b7fb89cc893766"
    sha256 cellar: :any_skip_relocation, monterey:       "56b2e1c9a28264dcd38c921c3678f5cca5f8f605b3e6f21b496e9e3aaa9c7b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd176c53b6009c94f2539d79de70ecdd8d09185c5a1d33e4869722adc5bed45"
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