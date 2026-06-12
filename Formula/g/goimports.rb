class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://ghfast.top/https://github.com/golang/tools/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "edef352ee709b80c2fcfaaebfbc04ce1dc20ead4dc34a325b6b1f5563ef36d38"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0962ccc833f9e3730942a9b049af3b4e86af9bdc1f6166c3f0fd1e90a267c89c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0962ccc833f9e3730942a9b049af3b4e86af9bdc1f6166c3f0fd1e90a267c89c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0962ccc833f9e3730942a9b049af3b4e86af9bdc1f6166c3f0fd1e90a267c89c"
    sha256 cellar: :any_skip_relocation, sonoma:        "54d1dfac9e4e61bd73e1f3981bc6cafe90a5945070a471674e24e638c5ebfcc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56373b9d357c8fb7de4a1b9040477fcb8582381994acc9bf995d202a681d13c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da3a632bb7db4a5e2deed824c1467cc28b63aae8a1920b6e8a7302508eed9e1"
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