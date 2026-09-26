class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "f366bbb1c6df421aeb61a2199eff6a5363d9b9cc9e83c3460667f9c5bc8b84cf"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9e77aca9709e9bcfec0a0d6e35b268a2aef7e2f924921bac303a9d771d1d309"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9e77aca9709e9bcfec0a0d6e35b268a2aef7e2f924921bac303a9d771d1d309"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9e77aca9709e9bcfec0a0d6e35b268a2aef7e2f924921bac303a9d771d1d309"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b57dc467077eaf8336ccd39602dca32a22abb9f7c97eea09286b4f8e3767197"
    sha256 cellar: :any,                 x86_64_linux:      "2aac12eb1f79443c5e38be1ed2a08f7fde77ba57a766d436a8d216777351f89e"
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