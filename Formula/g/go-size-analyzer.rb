class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.7.2.tar.gz"
  sha256 "bb59def342bb62b4cf5d92ac9db926b0c58e7aa59bc3ff0ec3090c95bfd7323e"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5498295ad80c0c929ae7fa2113ceefed2ef8e9438bb8dc1e71e9b7073115f718"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c10fe9f352a14a495f5a39a0e94a118d0f595c1494b705a8092105933e1953e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f6bb06824c899c473dbf9b10f4d9688f143b1f1a4c6c9a0133bd0c95ac98f91"
    sha256 cellar: :any_skip_relocation, sonoma:         "9398ab08300ddd1b41b8792ef2d645721f156149df57790bceda3230f28c264a"
    sha256 cellar: :any_skip_relocation, ventura:        "e1b87665b224254c9538105292c9d31e315e6b9c3a4cb0f36002b1a79073ccb0"
    sha256 cellar: :any_skip_relocation, monterey:       "33bbdd9976612fbd0d3d5166b9913df05bd05808b865ad4aeba4e42cdef03ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76dbf436cda9761dc48c9c264de7c8e1eb5a2962d1607a059ef11e57a3f7bb35"
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