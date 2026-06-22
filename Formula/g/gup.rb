class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "ac521634e858a053d84dfa81f978a72db5c8d795ae49b471eecdfc089bca0294"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ca10d7a09234d1b49ad4f5337abbbf2e2b2bab71d37502544eb3794435355cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca10d7a09234d1b49ad4f5337abbbf2e2b2bab71d37502544eb3794435355cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ca10d7a09234d1b49ad4f5337abbbf2e2b2bab71d37502544eb3794435355cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e18337e36a37edcdc1d453a405d3749f9828c07c017fcb9b0f06e3e740b14ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e4cda11aa51be5db1c9802cc586dae258974f4c45340a2153ab0566faecaed1"
    sha256 cellar: :any,                 x86_64_linux:  "7d0af2e2f75d1cc9380e8c312f4b0b7543ab8cb76ce0804daef81ada1b70016f"
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