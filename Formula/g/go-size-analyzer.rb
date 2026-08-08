class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://gsa.zxilly.dev/"
  url "https://ghfast.top/https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "58d178ae3301be679ba38c140401707b5b5562caba6836711b6677910b520ba7"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "996a921d5c05db2f3e932981f090126feb0b5737ee759df66a7aee1597cbbf5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21d3a8ce003fc5ef9d4a8089cb5a93ad5e450a766d7701f4b0cf95470ae9b998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e81dd452daeb1e040c64d04db043c76445b6928a5a17ed508823808851c2a90e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c87e682ff5e0ec22de1b6ecb88985e934af34b364c5206764c3727a3f0425915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4ab95ab2cd5af9bdcb3a96639915e520b13410a1c15cd62b89a084c73d21936"
    sha256 cellar: :any,                 x86_64_linux:  "397dec51ef841f8f866a6b0316210159dd4b642665e0db1c23b61ce000f19e38"
  end

  depends_on "go" => [:build, :test]
  depends_on "node" => :build
  depends_on "pnpm@10" => :build # frozen build (default on CI) needs upstream changes for pnpm 11

  conflicts_with "gwenhywfar", because: "both install `gsa` binaries"

  def install
    # Prevent pnpm from downloading another copy due to `packageManager` feature
    odie "Switch to `pnpm with current`!" if deps.map(&:name).exclude?("pnpm@10")
    (buildpath/"ui/pnpm-workspace.yaml").write <<~YAML
      managePackageManagerVersions: false
    YAML

    system "pnpm", "--dir", "ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir", "ui", "build:ui"

    mv "ui/dist/webui/index.html", "internal/webui/index.html"

    # Set experimental feature for go
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -X github.com/Zxilly/go-size-analyzer.version=#{version}
      -X github.com/Zxilly/go-size-analyzer.buildDate=#{time.iso8601}
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