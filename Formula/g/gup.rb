class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "bcfaa2db60f353b99939532b7464e1e9707b1594bad225a35a52f6b9a5f6d7be"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b16165c453a1cf2b4295799916d8abdab2d847cdb6334d420f4998c6f923249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b16165c453a1cf2b4295799916d8abdab2d847cdb6334d420f4998c6f923249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b16165c453a1cf2b4295799916d8abdab2d847cdb6334d420f4998c6f923249"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b73b6929c6bd5abbdcd663b5a1bc51731c7cef7209d9f69c35b6dc404e06715"
    sha256 cellar: :any,                 x86_64_linux:  "8d4c773991a2f95201489921650809c95eb028bcdda4cd6ed23e88a0ac80299c"
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