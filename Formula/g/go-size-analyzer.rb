class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.6.0.tar.gz"
  sha256 "f583490683bf33ca66806922aaec7ca9f08dcfa871becd36b866ad7834ca143a"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "005c5fa9b752225e6099b0cefc6c9b178b09a71123ed85b274414d3dbd38dde3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d00fc378fc3d5bf536f26d6a3e56e03f10b0583c9a02771fa36996a1c3cde54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98afe5ba53dcc59ff8aa4965a9168bbcfe9eda4d3505fd5cfdb6f9ce8e23e12b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a83f03c610076cf99bf2ff61c727735c26d9b09d9d4528ec15e9e57cb6a988c7"
    sha256 cellar: :any_skip_relocation, ventura:        "363262a4704655707ac2459f11a02ddb4ccfea0bf237a16e49ccab999e0e93e6"
    sha256 cellar: :any_skip_relocation, monterey:       "dabf9764c3c67cc0c1eb7b3174d7baabe6d0b7d725fcbcee2af4da06a3098510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dac3c3b78fbb77569ac800a1de90f124b2ddd431242e132e07fc870c43d560e1"
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