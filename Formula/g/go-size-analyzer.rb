class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.4.tar.gz"
  sha256 "5fbd976eb11758e4d579c60dc5cb894dbde93768ee01c935cb6c8bdd0ea6fad4"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef99760719e9658bdd6a0e25ff01eb7e67c4e0b86b8398a4bd7d3e19523822f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1a0130ad45e0c8ddf3b32dfc0fce604538890e72b02f34db25a464526b5445c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b94b0ea80d59d345220aba2f836a8ead06922d2ffe605e0ba1f6b1b36cd01f61"
    sha256 cellar: :any_skip_relocation, sonoma:         "c11e673457b94905d6f2d818bf06e27a2581bc23c6c87ffeeb51cb2be4a9a63f"
    sha256 cellar: :any_skip_relocation, ventura:        "d59cd627f3c7bc045129fcadfb951cf38df690a700a6f53d50bcf8f3f4f16dbe"
    sha256 cellar: :any_skip_relocation, monterey:       "b576c01661094c8d1869752559169e8e2af9f9ea23d08c5194b3ed7cfd8dd402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba636b2e93887256976890eb4dd7e3094a9ec4bd5e8e3ea4949c3c240a02284"
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