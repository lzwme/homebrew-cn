class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://ghfast.top/https://github.com/golang/tools/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "37502f684d90806c9aabdaa4912ad62e406698bb3d94041595162026103bd7e6"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "edaeeb16dee2daf1e0394eff58d8e39292300f98ea95467c0b005fbd56dc0684"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edaeeb16dee2daf1e0394eff58d8e39292300f98ea95467c0b005fbd56dc0684"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edaeeb16dee2daf1e0394eff58d8e39292300f98ea95467c0b005fbd56dc0684"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c98fb797d875b5df2f273b24374ddf34c03445550e3b29391c15f55c3df0ee0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c80a891920f8414a80d9084267a9941bee50fe4b59901d96154b360c046d86fa"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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