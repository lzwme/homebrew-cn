class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "c20d5b524442437f17d746040cc27d496a5c9fa180d31f07a643c33984053f2a"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7115bdc618beecd0aa7d62e856cb71164ecfb1bc49097e5558f3fd87a338d93a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27a994704a5b6abdf0fbbbea359a85d3471cd982e4485a187c26e8c7423156e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1840b35031eee7baea1ae818d17467d7ef41ea38920571853611b20cf2ef1ff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "56dea024eb1ac892c62c9e586097f6cc425d030a93731c6aac9580013101b352"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecee44d22dd06031a6b54bd63a50c10e21bb57c33fd1361a648f47912cd48543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f76ce108506dad25fbdd764ba66d524506ae0b60fe4f8a48b5ec13da5ae79ec"
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