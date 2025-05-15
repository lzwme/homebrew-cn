class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.9.1.tar.gz"
  sha256 "79b3166631a2999b71db9a4260d839678e49a9eafb09ab71360d0494a9842400"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9dd523f848770a330d7ac0dacfd513d66ceccebca38e084babca9d92ce979a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55df6313aafab3571041218c5ca814567d99773036d52d34b87e2e3a076ae8bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2e3a09fd77c6cd5097da865f48b420cd7fd872ecbda8d9174325aae00e25d89"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb3f4a2f8e761d783d55cfc559a79b284a54f27ef1ce150d247238e5bc9e87c5"
    sha256 cellar: :any_skip_relocation, ventura:       "6589387fa1bc57f37ed797321d6d8f13d58b38b3ae747bd5971144036ad84d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "756b33dc6811da6e5d06525cf5f4521d7f01f822ba53137c046d04d8be207a54"
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