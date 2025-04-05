class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.7.8.tar.gz"
  sha256 "482cdde972259a996c2f00d61cf99662723176404438169b62dd05db6e2e4683"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4747e2962e993342b6df39922f4f3720ca7bee80f63b4b6a2848401c499d3207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a8a57a1d8900a66f0cbd82a3f8c6732a67a202f09d061a1484d3bb1d5fba568"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5657225d832bf016c41f383ec3a21dffd9bae2d9fb67b889a54c90bbdcb872a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f2bfd5a70e3e5102fc3869b82a245ae8bd743b5036bbfb293bbac0e32df3fda"
    sha256 cellar: :any_skip_relocation, ventura:       "d3a862e02dda86e98c07299ffd683d9b07597378ee3ccbbad8525b27ce439cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a54adc8bd17bb3ed2d8562b0d2f799674938eaf936bcf381e2fd7c072d831f"
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

    system "go", "build", *std_go_args(ldflags:, tags: "embed", output: bin"gsa"), ".cmdgsa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gsa --version")
    assert_match "Usage", shell_output("#{bin}gsa invalid 2>&1", 80)

    (testpath"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    GO

    system "go", "build", testpath"hello.go"

    output = shell_output("#{bin}gsa #{testpath}hello 2>&1")
    assert_match "runtime", output
    assert_match "main", output
  end
end