class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "99271e45e7308636ebca3ba1b80de2cceec45c8b23dca4c2a508972974c58787"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "408358c22b26f43361fd7539e8210a240fbb60bbf98a88ce81cf1b35ed98ac14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea960a208c44babc514aabe7fed8defbbb34b01b6fd5310359d12cf1fb79559b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21f8ff3ec8f18eeca6a2269d2a1e877b9d100734fb10e7cc88dcdc62423dc0e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a720365235b549e4e1aeee93790fef8724298a9f3b0a9147525f469b31a15987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05c2e9fb21564622b44312adf83efdc21d7a1ba6b50f6f793600d2d70595381d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576c3bd0be7676ccb53ad70a98da4387568a66a8346d9a7927ae48bef9832bb6"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gup", "completion")
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