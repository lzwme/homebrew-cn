class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.1.tar.gz"
  sha256 "c19baaf6268f6c044fffe9594fb80582615267bef9cc8272c9ad347771cb0e7e"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4487c934803a71aeeb553c27c630c897a8379b63034bcc945d5762ecfca868ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c5dbb56e9ef911a581aec948a56429783ee365f6106234881d79780ac8c69be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03efe1220a6f46c350d89afd373c056bb87f8fb83d793cea0b266c4a8f26da2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dd8efae154d662e45c7bbc258d07c70303149b20a86e3f9902c0879b2978c55"
    sha256 cellar: :any_skip_relocation, ventura:        "9b7989dda2b5e180ae33fb43f04bad3832b6f11b2f5ac4477af4885f8b63b231"
    sha256 cellar: :any_skip_relocation, monterey:       "e5abc95430a794a16570aad1c8efb29e16b8cde880e2b596e59ebb5ccab56b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f779f938605e64129b511e180ba99a9d6ce2f000679e888e543059758ab5776"
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