class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://github.com/Zxilly/go-size-analyzer"
  url "https://ghfast.top/https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "b0f9bfd3acdab0ce68c3c44cae8f20b9b0831f0ac80ae67cda9c7dbcba3e1898"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40d87b49245512c5ca9d7ea0036920c811537d7ff31f4748f66f134b9e16f23a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7bb6bfa39c2506e4a819b395b7f3d1a1c45c743fde3603414ab24810356531f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78dcda75af7afcee3cc7ca5d1db80b5bc430048599e87bbed6ae7a318f729a90"
    sha256 cellar: :any_skip_relocation, sonoma:        "50f82f1a24355ad8d011c2b9ca302c2cdf700bc94ce1740bda3dfab68f050108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2634401e2279bd7ff30f9ab408176b40b6337321981ff560c2bc9a3df7417e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f54b3342e5214a3328192eb7e2dad53fa81c0093a22aac9dc0d019eaf46341"
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