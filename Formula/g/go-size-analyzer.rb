class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.8.0.tar.gz"
  sha256 "841cf33237d5ad57ee422cbd2ddd8c9bdfe8db7d35f36f2462e0aa492f942e65"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "462a94c506567ef1e1620a9747200349997f026cc42186ea84606eda796d191f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c65c8f23becb094ac8f45f69f54118860a2c49aff0e9c2a4d420c93cee85c5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bc4dfffeacb3b4736b1c178de4f4575dec055e04a5ae5627134288fa2ae8678"
    sha256 cellar: :any_skip_relocation, sonoma:        "572efa13f39a76688423170d11b062574c238a00091b8f1ff14df76f0264bbc8"
    sha256 cellar: :any_skip_relocation, ventura:       "4b8f099904089e031ca42052065445cf3ad90e3370899968b8e049aa7aab5ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "063149e9a4d57417c22964a47b819e6b04a00024f5dbbb2844b4d49bdaead867"
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

    (testpath"hello.go").write <<~GO
      package main

      func main() {
        println("Hello, World")
      }
    GO

    system "go", "build", testpath"hello.go"

    output = shell_output("#{bin}gsa #{testpath}hello 2>&1")
    assert_match "runtime", output
    assert_match "main", output
  end
end