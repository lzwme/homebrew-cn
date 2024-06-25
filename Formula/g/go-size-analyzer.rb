class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.3.9.tar.gz"
  sha256 "6d208d53361f10c1b3bfab65d7ab3edb6aa7353752e9e5d79bce2403c7e17da1"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a37907e235e3fcc1c814402cbd72d60ebfea1264a515ffdd2bc64477fdf76f61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80a96bdae0629d72173105ba927344cd38d74178b9849fdb4347c912a26ecc33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6d4bb5b83efeca5a3df3f693739eba9eba37f0eb7151ae36a57139c446a8bed"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f72eaa31dbe6cbba885d048c31bf8f289860835b327c40c0dd37d3eba5e3491"
    sha256 cellar: :any_skip_relocation, ventura:        "2e1d246c2b4deb21ddd0638ed3653ffec84a3a2c78a25a053a50766ecab362eb"
    sha256 cellar: :any_skip_relocation, monterey:       "230b4167414dcbc2dfc0918991f7593d869bc776b0f8768af02b33feaf7a7ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d21a31f5aca1c0cb9865871e2923735ff60421e279f38f2ae2a30dcc3983de0"
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