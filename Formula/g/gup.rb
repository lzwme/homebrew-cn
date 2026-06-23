class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "7796044ac6e7da3b72768d592077c887112c80e7541a87816a5d562f1a2fb597"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ded555263e67edbaeaefeb4367c94f369c0b9b3dd9e44f4413677c108353023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ded555263e67edbaeaefeb4367c94f369c0b9b3dd9e44f4413677c108353023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ded555263e67edbaeaefeb4367c94f369c0b9b3dd9e44f4413677c108353023"
    sha256 cellar: :any_skip_relocation, sonoma:        "f828533a82996b1e9c84a9f8bded887e40cdff0dc106c321e544591cb500a820"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ad29d7665aff23ed32d11193566e0045bd415ed80b9add51b20b72350c39933"
    sha256 cellar: :any,                 x86_64_linux:  "f04b37236365d889f8bf4c1aca441ff9eb996b86b93300f7fffd63189ce5ca3d"
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