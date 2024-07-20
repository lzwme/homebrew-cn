class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.5.3.tar.gz"
  sha256 "fe9e681eef747e6e65d419dca586c20831c9bc74e519a7b41d2eba257866586f"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c092943a3b1fe9eb5d771bb399e7be91de1f07dd090de3dbfa23a8500baf67fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cde90f85c3e8dc445b8f8ce38647bd2da11eb3bb697c581ea72d30ebac20df68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e326cd8723ad9cfd5773858aee3dd9a470c589254d0c13dfa0c9a55dfa07bdde"
    sha256 cellar: :any_skip_relocation, sonoma:         "753e9a2d112ed364f9aa4f180bd2916e08ba272df71679798ee9bb53138e96a3"
    sha256 cellar: :any_skip_relocation, ventura:        "2272f9350f4281a0b71262e81a3f68cd244fb02a712193119730b57f71fd73ee"
    sha256 cellar: :any_skip_relocation, monterey:       "931787223bab06f052796574aa6c5545a358d27cc40ca27fc56fe61185a299d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6719bc54c0e3b9381350af52e96705f5bcc136bf3b2cbac93e47aef406b9ace2"
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