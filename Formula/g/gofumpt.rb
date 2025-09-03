class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://ghfast.top/https://github.com/mvdan/gofumpt/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "0fe46851740bc4146f1e2ac0b23ca67a481490a603db189cae35a4be1787092f"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/gofumpt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07e39d7b570c1e33f56c13a4c1e32bec18a8f679e49ba7f46872d9959b4fd59b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07e39d7b570c1e33f56c13a4c1e32bec18a8f679e49ba7f46872d9959b4fd59b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07e39d7b570c1e33f56c13a4c1e32bec18a8f679e49ba7f46872d9959b4fd59b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d6ac3f4c453c0570bf7feb57cfc6fd4768d4657275be92dda213041cdd9fa70"
    sha256 cellar: :any_skip_relocation, ventura:       "6d6ac3f4c453c0570bf7feb57cfc6fd4768d4657275be92dda213041cdd9fa70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5443b3aa9410088a1abd34cf2952aff344a6ab0874449c27978192eb28cb1a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bc4ec01da08b5bc0230003cb5d8f445799d87ae7dced86675b46d55bf08f2ed"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"test.go").write <<~GO
      package foo

      func foo() {
        println("bar")

      }
    GO

    (testpath/"expected.go").write <<~GO
      package foo

      func foo() {
      	println("bar")
      }
    GO

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end