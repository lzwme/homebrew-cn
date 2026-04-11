class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://ghfast.top/https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "9758a75d46b0592bf8dfa84148dc249fe7a66d55270513b7b0c5fb79a3a3b851"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5244d6e7723ef9ba0fa17a6ef0b67165ab26d2639b54386302889bd1e6aaf8f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484319e54d3663ab2fcc8894a3175bdb2ef9243fc0e691aabeafb4515e0f384c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c327b3ab64b00b0c2cddb9daebe8ea5282f3aebfd9da33d4040d2b3a8640939"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd7322f7a3229d47c89f7dd7e51f814772501b1f8dbd13b03914014b1a98ffd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc9232ba99e4ccf5cf305e0e2752bfc8a427a9aaff044ad601db3742d3b452d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e5956490bc3de4791985060d4640aa8f57123e64c382de9b6d841babff55f4e"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm" => :build

  conflicts_with "gwenhywfar", because: "both install `gsa` binaries"

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "build:ui"

    mv "ui/dist/webui/index.html", "internal/webui/index.html"

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