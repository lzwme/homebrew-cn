class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.14.tar.gz"
  sha256 "3c5f2a70fac1097c1b66737fd3034630c65039cb9af50afa7cba02e526300adf"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1c746943810182660679b07379b0f38a108c96161fbff13ac9069b002107dcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e09d35202e90434444c33cd3d81db4c83e97dda4cba6891f37486c98dfa198ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c33e3ed9ed2f565b1702bb592dfc70c13b7c3ba92d08b424521cdcf297cb88ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "b526f63fb58cb867de203410554c9830b29fa3b7488cfc1283e89306dc930bbe"
    sha256 cellar: :any_skip_relocation, ventura:        "7926333acc0858e33610966e5b8ecf7f67a9f7093c726a27d292e08292486f51"
    sha256 cellar: :any_skip_relocation, monterey:       "fe23c8a61b7bd367fd08f8f589bd7225bb9efaba01c69fc9b9325609ff9c0b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "145883a5cffb7c53702c65dc74d9cd7c740a25690f1dfa9149058c665a8c6f14"
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