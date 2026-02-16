class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "fa80f65a46bffe35849da65be47bb477aeb63a6b040b9d2592e39ae139d5871f"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07060a9cc54b3d988694487cbec3d5ce7feadb36712ba77bd5927e970d53b538"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07060a9cc54b3d988694487cbec3d5ce7feadb36712ba77bd5927e970d53b538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07060a9cc54b3d988694487cbec3d5ce7feadb36712ba77bd5927e970d53b538"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cdfb65c8f0f298c4aa9ce022122214cb07683e4e02c070fe4fd0a6faa04caef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6360d213f483581ebe52e0c3e8ac9a99d34aa2b68b7b646fd5ca58be900da01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31355f33b32185085e8db3a5a2df2b6e6c1ddbb25191b62281c01db377505956"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    # upstream bug report on powershell completion support, https://github.com/nao1215/gup/issues/233
    generate_completions_from_executable(bin/"gup", shell_parameter_format: :cobra, shells: [:bash, :zsh, :fish])

    ENV["MANPATH"] = man1.mkpath
    system bin/"gup", "man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gup version")

    ENV["GOBIN"] = testpath/"bin"
    (testpath/"bin").mkpath

    (testpath/"hello").mkpath
    (testpath/"hello/go.mod").write <<~EOS
      module example.com/hello
      go 1.22
    EOS
    (testpath/"hello/main.go").write <<~EOS
      package main
      import "fmt"
      func main() { fmt.Println("hello") }
    EOS

    cd testpath/"hello" do
      system "go", "install", "."
    end

    assert_match "hello: example.com/hello", shell_output("#{bin}/gup list")
    system bin/"gup", "remove", "--force", "hello"
    refute_path_exists testpath/"bin/hello"
  end
end