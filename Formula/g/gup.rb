class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://ghfast.top/https://github.com/nao1215/gup/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "2e9ceb2e96bfff8179729d6d91e87581a2509b1957de9a3e05f6ec879bb101f3"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab161f396261cc6dbf9679750663f4a446276a538bababc4119306f99413bd02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab161f396261cc6dbf9679750663f4a446276a538bababc4119306f99413bd02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab161f396261cc6dbf9679750663f4a446276a538bababc4119306f99413bd02"
    sha256 cellar: :any_skip_relocation, sonoma:        "12ccd15b44b860b35ba75f91064690b5a6f37eb21fd2af6e229276cd63dcc1a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "887b8516360a4f3fd06d44194c86110d3fe16e1ec1bbb9fc024ef19a52c8995b"
    sha256 cellar: :any,                 x86_64_linux:  "47008d3ffa8e06c0dfc54c4d724f1a1f8b80684a9afebcb9a9035a63814b9b73"
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