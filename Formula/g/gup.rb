class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "b3d8d285d0accb4062bd47cfb9f6623a8b97c424193ff260cd5aa46cd14bbc40"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "663cffb68a124ef83c1123497d369f9961e5a6fd695b4665963c2306894c95f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "663cffb68a124ef83c1123497d369f9961e5a6fd695b4665963c2306894c95f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "663cffb68a124ef83c1123497d369f9961e5a6fd695b4665963c2306894c95f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "00974a2d868653acade4e7bfba7ca0965f146b71a8bf57c3eabc61791f966e25"
    sha256 cellar: :any,                 x86_64_linux:      "8ea4a74fe40ed2a6b58449d7e3c588bf396ef76da14f131241edd86231af637b"
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