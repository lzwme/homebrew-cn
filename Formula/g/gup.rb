class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "c15ed39efb18c578837e35ccebd9cc3e468b08d25443ea482a0b85a57369cfc6"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3c6de979fe3954f6ed590e8759548530c839814bb2d08f1af4ecbc9515f1422"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c6de979fe3954f6ed590e8759548530c839814bb2d08f1af4ecbc9515f1422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3c6de979fe3954f6ed590e8759548530c839814bb2d08f1af4ecbc9515f1422"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f937d2733232a5593efe96b5db87e4984175b48b664acb20462a6774bf28e52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1813e90f829f8fba29035f973e44378612fbd0e522a20edbf90786847b7bd1c4"
    sha256 cellar: :any,                 x86_64_linux:  "2b01ee441dd4d896f3581587c9fd90377c9252b1462278d40d83e80c639e29d7"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gup", shell_parameter_format: :cobra)

    ENV["MANPATH"] = man1.mkpath
    system bin/"gup", "man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gup version")

    ENV["GOBIN"] = testpath/"bin"
    (testpath/"bin").mkpath

    (testpath/"hello").mkpath
    (testpath/"hello/go.mod").write <<~MOD
      module example.com/hello
      go 1.22
    MOD
    (testpath/"hello/main.go").write <<~GO
      package main
      import "fmt"
      func main() { fmt.Println("hello") }
    GO

    cd testpath/"hello" do
      system "go", "install", "."
    end

    assert_match "hello: example.com/hello", shell_output("#{bin}/gup list")
    system bin/"gup", "remove", "--force", "hello"
    refute_path_exists testpath/"bin/hello"
  end
end