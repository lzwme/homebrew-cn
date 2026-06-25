class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "0eea4ee4070256dc98c2a8c523a61eae6a4089373e3536ceab60f353974d77f9"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac00c614cfde959bc78b3cab42faf509beebdf13fd66b79ebd22356c14b19343"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac00c614cfde959bc78b3cab42faf509beebdf13fd66b79ebd22356c14b19343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac00c614cfde959bc78b3cab42faf509beebdf13fd66b79ebd22356c14b19343"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aca7c11e8c9067dd96c0e480327505fe0ad60cb84769502493cf3113112eb41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fabda5eaa2003fb6d437c236f8eea9ca72db6da809bcff1f004b8331d54754f"
    sha256 cellar: :any,                 x86_64_linux:  "9d8cca6b4990acabed23df15deb1bdf9dd434b688b9bf38c91198387cf2c0ce6"
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