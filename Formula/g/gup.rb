class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "0fd240e3e1794a1109914327f8707aeffa4ad7f758aad8bd4c0ea340add2cc4b"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d95abab99044a184902ded8372bf1d875453ad0c7e5bffe713022d51a0dc4844"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d95abab99044a184902ded8372bf1d875453ad0c7e5bffe713022d51a0dc4844"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d95abab99044a184902ded8372bf1d875453ad0c7e5bffe713022d51a0dc4844"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9aef0945db2a47a14ef1e54c160dac0b3b6cba9d06805dddd18c76391614dd50"
    sha256 cellar: :any,                 x86_64_linux:      "185d14021029d974ef53c79ea6d68c677b44432f1c945509b95242cd0de4fe17"
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