class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://ghfast.top/https://github.com/golang/tools/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "e39e3550f2881d7c54ca3fbba3ef1ad8901bd82135579b67412fd412ca7d05c2"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abbfe31a84c1f2c9c0343291287398412647502e1617f103336c05d6b1be1fd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abbfe31a84c1f2c9c0343291287398412647502e1617f103336c05d6b1be1fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abbfe31a84c1f2c9c0343291287398412647502e1617f103336c05d6b1be1fd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "39dc174c70326c5109429406b0533870fae85ad5bef7c95cc351e23f3d7ec524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfcda2caeb8eff5e9a0cef4302a58b2d8646fc26360e9328ce4a431e1ea4e537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68902bfe2293b4ea5e77b8b0696e5dc2b70b717389999907a25cece63ea19e5"
  end

  depends_on "go"

  def install
    chdir "cmd/goimports" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        fmt.Println("hello")
      }
    GO

    assert_match(/\+import "fmt"/, shell_output("#{bin}/goimports -d #{testpath}/main.go"))
  end
end