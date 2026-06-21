class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "3ccf73ef5112dba618ef28577b06189f49c5f487a9ca1463f963ae75f4473369"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d91f1fc30d7b6a401112a0ddc0fc9d47b74acb8917dfd271524e879aef3c639"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d91f1fc30d7b6a401112a0ddc0fc9d47b74acb8917dfd271524e879aef3c639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d91f1fc30d7b6a401112a0ddc0fc9d47b74acb8917dfd271524e879aef3c639"
    sha256 cellar: :any_skip_relocation, sonoma:        "b61c5ef396a16978cd847c19fc274849adcbd3d43287086a8a78a8283bd21754"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80791208e9eea728b7d3734c7755762b9f5df13603533440cc3c524cbd2dca3d"
    sha256 cellar: :any,                 x86_64_linux:  "ec1760ec5bec99c3388a160e552f850a093868ef90e5cccfea82fe2aa0c8cd99"
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