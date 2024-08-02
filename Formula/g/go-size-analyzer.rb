class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.6.1.tar.gz"
  sha256 "da050e7cae3b6e9dd2cf2239d902048d74a47fe1e299b7201aa0025ce2984050"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a415a9b83203090085cf4f37b772c2ea9c6503c0d5220b18750f77eace0b06ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "811251fcbc07325f5ae1eae68fb3ff33dbe63c2f21a964cad42a43c436e5069b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc843f143ea5ffd05bf2da386be741742a155f3b73563d6d9a7cd78d603e455f"
    sha256 cellar: :any_skip_relocation, sonoma:         "52adb90d2356c23afdda9b7e5244a242ce6c33bebe583cf5abcddfbb4f76fa93"
    sha256 cellar: :any_skip_relocation, ventura:        "1be11fd26b838d4d736a478023476bcab76192cae592bc4389c2f90791fd114c"
    sha256 cellar: :any_skip_relocation, monterey:       "47cb44af06e04a97ee27c89527949a5101c93849beb68be9276371adc13dfc0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff44e444ca15a99e4d87e5f4322be8dfc08f5a02895b6661e1ca0cce2a22feb5"
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