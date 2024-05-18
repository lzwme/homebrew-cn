class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.0.8.tar.gz"
  sha256 "5fa7bea825991444aba84237686d7ed8c4682ab9078ece19a2037af9906d7719"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9f1240b7d13bc7adc668880aa8c083688b3f8d7ea1e896a634bb1f529f43faa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60c222e201174e3d1a76caabb07d6f5cc3e2fe52778181cc955a24b529bdfb71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45304f22a1545484755057c3581e228f1f675cb24421a2ca3f407ec34662a738"
    sha256 cellar: :any_skip_relocation, sonoma:         "223efe0decc271861d64a5ed477b80ab87d6126e24927aa5564335a14993703f"
    sha256 cellar: :any_skip_relocation, ventura:        "0569660acab193eb0dccd716c161e1d5aafde09ced21eff82b3e5bc2d54b5838"
    sha256 cellar: :any_skip_relocation, monterey:       "1f6927d61fab444198586ae23ef0ef488eb24193f62b54a87ff564eca901f7d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c7cd560ab85dff8817c5d09dcbfd0da5a7e972547eddd5d873e337ce98baf54"
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