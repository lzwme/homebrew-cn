class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "0756d1780197dfa66763084969272a37ada578acd9428a6e63b62ed4bdf8dd66"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e24799e76c5285b1e3d411cead819b29f9df318b1c299b12f9986447d85a99df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e24799e76c5285b1e3d411cead819b29f9df318b1c299b12f9986447d85a99df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e24799e76c5285b1e3d411cead819b29f9df318b1c299b12f9986447d85a99df"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ffa0f2ef48a2fb757c6e550df59e18c226fabf19088d9c6a81404182f0938e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f87bfc461bbc23061b8e3aa7ae0e559463585e8db558dc5c8443e180352c030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "720959564658bb8d3cf501337f80fc8fe6ec2cb0f3146488e69f3d3090b9632a"
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