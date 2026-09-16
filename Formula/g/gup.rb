class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "8ad29a1dff6c0d78da82199709bc913ce9a7bcc8a8057166e0f6368e4d50c19f"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57b1d58bceb586943e7bfef899f81db6dee5d0d7439868299560e6e9d4f816fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57b1d58bceb586943e7bfef899f81db6dee5d0d7439868299560e6e9d4f816fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57b1d58bceb586943e7bfef899f81db6dee5d0d7439868299560e6e9d4f816fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86e90d577358d68bdb317cc33b2d6bcffddddbf1231d05ffad468c08328ca4d5"
    sha256 cellar: :any,                 x86_64_linux:      "91d771db00a984ee61c6d14b4b090ad512c8447c9676198cc17153a3b644826c"
  end

  depends_on "go"

  def install
    ldflags = "-X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
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