class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.7.1.tar.gz"
  sha256 "165730adb9f6b5e0369b17d99eb1659adb0ec130e59006086e5e12b14bf79cd4"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9c417960dd046909747273ea963c7f311a5414e7201feb6a4a2bf970f47a390"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d648af72dd0e1d0a07cddb47648cd5949c2cb22b0953787c01f84b914066d1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0235167a05bce4a1086bec55d04467b18dc79b9c4e5191c498d002861d101935"
    sha256 cellar: :any_skip_relocation, sonoma:         "887c019a478a72ed0d9e58ea2b696d7503648fef427bc474eb6dcdcb2742c287"
    sha256 cellar: :any_skip_relocation, ventura:        "3b114028700ed1f4352704fd82c9090c849dc7714f924e7d3ef48e947528f7ea"
    sha256 cellar: :any_skip_relocation, monterey:       "3a3eae3a42897a0b82ed5d5fcccdaa008d9046ab3e91380c41734b588e97a736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3aff476af12a4b8e560494ebcfb79d631e1281339cf761d9be17c9f271e725e"
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