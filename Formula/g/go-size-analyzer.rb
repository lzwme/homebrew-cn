class GoSizeAnalyzer < Formula
  desc "Analyzing the dependencies in compiled Golang binaries"
  homepage "https:github.comZxillygo-size-analyzer"
  url "https:github.comZxillygo-size-analyzerarchiverefstagsv1.5.4.tar.gz"
  sha256 "39a0b7bc7609de0a8cfbb6e7f82b41b2ca460bab24e981b1763325905dc9baa8"
  license "AGPL-3.0-only"
  head "https:github.comZxillygo-size-analyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1eb3aa8c70fb68b78902ad33fb55f88e21725e1ae4c431dc01bc3b8cef6ee455"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72430d2f533a0cdeaba98be19d8a0dd3461406339a5fcc4a731c307671b9d2c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96183ec856a3523013417847faa9819a19172b51fc8fef0b722f6b2f183a80ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "c185bf8927e7be82ed3e9c45c7a8605f0e1ca73c3f35aa11a5bdcc9243419e42"
    sha256 cellar: :any_skip_relocation, ventura:        "b091d88d8619219432ad86ac6f9d104a5c972f4a56f7f1f29e20cf6a51d122d1"
    sha256 cellar: :any_skip_relocation, monterey:       "0d32ee3516e1eb2f82a09af7cb3c547d427cee98db61e49936ced1d9917528e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef405910bb4508b42e671c36b6a05d40318d535dd966391980a76f78c87f9d22"
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