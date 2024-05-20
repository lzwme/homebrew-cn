class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.0.9.tar.gz"
  sha256 "18fdc0e5b2db2bce861d9ce51137d465b10752395da8c9b621fee56b7fe2c9a9"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ba297f0543a67b19ccd98a7c7517641ee63b580d1816555008c0577bc1c4eee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7ad3dbd367f23644493521f06fa9d224ec1603ad3f2722c347f97cb1782859d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd03938666d1e18ae2d15d1e66ff4b4970e94674baf3d4c8d5bde9fdba7d0e33"
    sha256 cellar: :any_skip_relocation, sonoma:         "90daa7fff149fae18cdbcb5dc43ee71214cf9d480d02b0169c97709be993a80e"
    sha256 cellar: :any_skip_relocation, ventura:        "bc0795236238cd3e151291e222588bf5637a7916bf7170316142fed8acee89a3"
    sha256 cellar: :any_skip_relocation, monterey:       "e36fcf5f013d78178c7488791e70f0b1fa893f151a9ac116bfec024cb17acb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17f1a8483a95cefab8d8bd4335f400d2120b54df61b61fdbf1d797dfc5932b09"
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