class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.7.7.tar.gz"
  sha256 "f1d57260a218f009359492a2a85258ad8a64109b716d81e0c2ef156db31a7a7a"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d00a53e16af0ad8465c11ade97efc2fff2adf106c78f8b57d5e8ee119a330d17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8764af22d514987da5c5a79ac7f3e8bd5e0c414c1d8c62460c5f34a259b46d0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f25d5a035c20a6009508ff5573f8338bffe14fb5aa4147a6876f68528d60eca"
    sha256 cellar: :any_skip_relocation, sonoma:        "05f5f2078fb9efa1e7e4fe676ea166969d2fa7eb867e359332295e84ca1765ba"
    sha256 cellar: :any_skip_relocation, ventura:       "2ec6c7cb0d9c5a398d4416e747de4500a04be6b8ab7e8487e9e7607a7bbd7596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "809675c57b926f455ea1bc5bf0911afe3bd4508d2615c65161fe4a5da845b987"
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
    assert_match "Usage", shell_output("#{bin}gsa invalid 2>&1", 1)

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