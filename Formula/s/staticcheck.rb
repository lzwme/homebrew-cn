class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://ghfast.top/https://github.com/dominikh/go-tools/archive/refs/tags/2026.2.1.tar.gz"
  sha256 "8d807cd909f4481d6777f7707e5ae75dcc399e14d68ff14a3c814731826e0dfc"
  license "MIT"
  revision 2
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27d14fee5712c5868cd45a459fd20eb2122b4384b053845b30fc720662f11b6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27d14fee5712c5868cd45a459fd20eb2122b4384b053845b30fc720662f11b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27d14fee5712c5868cd45a459fd20eb2122b4384b053845b30fc720662f11b6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14bef82d5616e1d707d285f83dfa091449f595360a46f622bf0cda5b16c76d85"
    sha256 cellar: :any,                 x86_64_linux:      "ed781efa38db864e5b8ec1b9a5fa8768358098bae3f3c3906e5182b10507f3c1"
  end

  depends_on "go"

  patch do
    url "https://github.com/dominikh/go-tools/commit/4ff8b865d12b49f3af67daf2294023336987dad5.patch?full_index=1"
    sha256 "19f123d3f405f779e82a739d3d6e7e3b289659b496ac82bd699586465b06ecc4"
    type :unofficial
    resolves "https://github.com/dominikh/go-tools/pull/1834"
  end
  patch do
    url "https://github.com/dominikh/go-tools/commit/01bcfe17fb93153091b35df4036a1d73087817ab.patch?full_index=1"
    sha256 "52ce80f83d597020938bb7c463070f3c133802995029faeb632e3fc385fb4d8a"
    type :unofficial
    resolves "https://github.com/dominikh/go-tools/pull/1834"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/staticcheck"
  end

  test do
    system "go", "mod", "init", "brewtest"
    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    GO
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json .", 1))
    refute_match "but Staticcheck was built with", json_output["message"]
    assert_equal "S1021", json_output["code"]
  end
end