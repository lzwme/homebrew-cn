class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "5f8d2a3131bdc3739c567e103fb1697ddd7464126f4c06ba0fdbf3a79d4b853f"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2a8fdfa3f39b58e6ecbeca39874e64764bf551725cb94ee45de982262643ab8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2a8fdfa3f39b58e6ecbeca39874e64764bf551725cb94ee45de982262643ab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2a8fdfa3f39b58e6ecbeca39874e64764bf551725cb94ee45de982262643ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fafa03c3a6b54c0cc70ea3531fb1c0ead5f221ffab36a966e4a38aa98255cf5e"
    sha256 cellar: :any,                 x86_64_linux:      "75cd75efa0d15898ab505e3c6599b7923982842ff90af999fd635d4903f5eeaf"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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