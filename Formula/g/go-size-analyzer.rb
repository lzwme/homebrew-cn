class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https://gsa.zxilly.dev/"
  url "https://ghfast.top/https://github.com/Zxilly/go-size-analyzer/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "c33d0ff8c5c5fd37cb30d8d6a963fe07a20f13cfe4bf2cf3832af93f421eee11"
  license "AGPL-3.0-only"
  head "https://github.com/Zxilly/go-size-analyzer.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e44b5546bd3055db4282cf6a2a0affdb4e763a9278e4ff34147a65068056f5e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "795c5eb237076023836f0a856c5c5d98800c231881a2302f81a428281563c405"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c424b76b93a8ce423aab4c105d20a34930502f0f230b840c17b196bd4d27ccf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "08f614c695e4a1af0fe97665eada89ff4c9c642851d2cbfdc329abd83d748b0c"
    sha256 cellar: :any,                 x86_64_linux:      "5b31cad705c0ac3be57fc6609423f5726de915f81a7af3b29e76b3a0f48a3d4e"
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