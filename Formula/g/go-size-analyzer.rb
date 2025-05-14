class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.9.0.tar.gz"
  sha256 "0824fdb357fbb8b679c160844ddf76086315fe73fa7383707e07d4c139d8141e"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "000dc6caa458ea104f69da4a8cf80bbb0868c0ff88384a7238a1459d67b3b512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff7869cb5538f9e1e82dc2a762eca8affd2d9bc1987981d1ab3079a755288702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c324edda7e56c0981f8942fc4c29befec8ad0bd7cdbd4c77f74dea013880e053"
    sha256 cellar: :any_skip_relocation, sonoma:        "67220ff1a03a683fc2b5b15c4003f0552e6411c15b182fe26c2e471b1bd0a7ef"
    sha256 cellar: :any_skip_relocation, ventura:       "0781699c91c5222ba2f8ab88cc444e9a504a7095395d690bc8cb704a81675be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ef2745381b213ede0374d1b13a61fccebd26055653a594230f8b8a60671a12"
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