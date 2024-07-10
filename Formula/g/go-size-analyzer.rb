class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.4.2.tar.gz"
  sha256 "98d195673cf7ab71633df4e9fb9ef53b7af720da9683522680ae4d4e757ae7dd"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6539b0745f5edaa04321a829ff3ab23e1bd93962bed454481ee65328fa9777e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "658398549e6c6bbc13b9b745d32001d9b48f7c5da34a66caab37c2bed0bd9897"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c757826c460852313d29f3d279de0c84a4997840e9dda5f0063e141857851475"
    sha256 cellar: :any_skip_relocation, sonoma:         "e362bd219232e8c986233348e9730810f65614df6ad507f18d0aa47dccc1ea15"
    sha256 cellar: :any_skip_relocation, ventura:        "40b8594d8cabc2e44a8a2fb75c4fd800dc62e4e0783bc4e8adc5683c7657d06a"
    sha256 cellar: :any_skip_relocation, monterey:       "e7a8939b17288016aa5d0fe60b82803ad6d091d0d07b82e1caeb2d978a0ef31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68e270440cda68356c709eba80880e8527ea665ac704106444cf4fc53ecc793c"
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
    assert_includes shell_output("#{bin}gsa --version"), version

    assert_includes shell_output("#{bin}gsa invalid", 1), "Usage"

    (testpath"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello, World")
      }
    EOS

    system "go", "build", "-o", testpath"hello", testpath"hello.go"

    output = shell_output("#{bin}gsa #{testpath}hello 2>&1")

    assert_includes output, "runtime"
    assert_includes output, "main"
  end
end