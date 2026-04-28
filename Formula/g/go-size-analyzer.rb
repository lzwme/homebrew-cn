class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://ghfast.top/https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "686f543ed4b3fe9b6c74221bca32fd69a311cb9224c2cdaca6d2553aefd3a925"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ce14b9c27303daff79a69e332d70796a094c1953b128252999a31f73c5cf878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "186bf5aeded618c4af3bf97f81697722119dcd10a7397b5685f1d2155ed55c5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10543ff77176179092fbff7079e2e4bcb222c2fec7321b10233054fd81cf4d07"
    sha256 cellar: :any_skip_relocation, sonoma:        "26c0dcfb9ac301c61f2c1d2ad3173fc4d2e5be60a419eca1e036a118cace7a34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84afe065fc7b8ea2bc85618754d871ba0d3dfa27513d1725ddbc058936994030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f8850088c30be5dfe3396bb9379c86d3485a1b45c1de0884ea9021c071c85e"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  conflicts_with "gwenhywfar", because: "both install `gsa` binaries"

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "build:ui"

    mv "ui/dist/webui/index.html", "internal/webui/index.html"

    # Set experimental feature for go
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/Zxilly/go-size-analyzer.version=#{version}
      -X github.com/Zxilly/go-size-analyzer.buildDate=#{Time.now.iso8601}
      -X github.com/Zxilly/go-size-analyzer.dirtyBuild=false
    ]

    system "go", "build", *std_go_args(ldflags:, tags: "embed", output: bin/"gsa"), "./cmd/gsa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsa --version")

    (testpath/"hello.go").write <<~GO
      package main

      func main() {
        println("Hello, World")
      }
    GO

    system "go", "build", testpath/"hello.go"

    output = shell_output("#{bin}/gsa #{testpath}/hello 2>&1")
    assert_match "runtime", output
    assert_match "main", output
  end
end