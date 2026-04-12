class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://ghfast.top/https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "2d5983923b60fe06659d6d380e012105c270edb0d1714a230f8a97ccd48d2fbc"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a679469ef91666638345e4c3f554e03b145a6265ed77ce23d922acd50bc9020"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb5e1cb171c19944aa2cac5231a28f2a0a7c16437c02a18a0ca54174b10bbadb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf91329f20d7697fca846990b0b69a9098ad600f218c7f58cf179e4a91e57ff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f44309f7656f7de4d0283ffebeb8468ba5559393e0ea751ab9629b6661a562c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34ca531eb886fb2cee96cfd1db2786db6e672a8bd678d5bdce4af55fba08f24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa9a973413a4c23b6dc557e9b73b60fcc0f763d9a7d1af6450cf809cb1854b2b"
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