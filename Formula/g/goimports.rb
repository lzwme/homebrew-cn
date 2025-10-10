class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://ghfast.top/https://github.com/golang/tools/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "39c2467aa441a75a5c758100291846ec5304f8f76fea2e89043071b7c526e113"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92f62eeffb0c23000c37cc06d9a05a8d81763a31f9b3aa881c143213063a3190"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92f62eeffb0c23000c37cc06d9a05a8d81763a31f9b3aa881c143213063a3190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92f62eeffb0c23000c37cc06d9a05a8d81763a31f9b3aa881c143213063a3190"
    sha256 cellar: :any_skip_relocation, sonoma:        "52305b343db96afe26383467348bf276988cb0f3a5c4741975a54ddfc94e3407"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c657b6e4ec745e3fdea2e8719a0204f15717374afd0352b157aa37c4efdfd014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27d9af556e5151c575e42fb35e0a11411ae8fe231e90ec711b03669ed10be9b4"
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