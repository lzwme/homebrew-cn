class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.6.2.tar.gz"
  sha256 "825bc65a098036b06410eceb31fb3a6e194fa4a29e2edddab83592152d04b230"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be66813fc93609943206f91449d703ce661d4cee79737c495413692c3a990b79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3b135f75bd98949fa8439d80c741582d6382a16c3176166157c1c057e12895b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d73a1ad16ba542e9ee7708dc2947db3139829193e24978db9b13347e497c404e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2eb581ef201170d26cd2c621bbfb844dc78f67722a4c6d1b17272599e0f2a99"
    sha256 cellar: :any_skip_relocation, ventura:        "793d55effa99027168348c6092be7937cdcc9c048ef33b8478cdf04353f9b727"
    sha256 cellar: :any_skip_relocation, monterey:       "4dd084b59f984e941cf383c1e2153f003a3e052f39ac8458caa3ef6bd133fad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1ff1c8183110c0caa5626a27bf136705ad1d7bde301512b629bc6f1154048d2"
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