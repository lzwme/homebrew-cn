class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https:github.comretepsdockerfmt"
  url "https:github.comretepsdockerfmtarchiverefstags0.3.2.tar.gz"
  sha256 "42646ac90bdc70c31717dcaca15595d97c8a3f9419886b8241446a29cf39aac1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e5791aeedf1e46a961eb9fe4eb8ab2f95ef8738a610fab8f22269bd041636f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e5791aeedf1e46a961eb9fe4eb8ab2f95ef8738a610fab8f22269bd041636f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e5791aeedf1e46a961eb9fe4eb8ab2f95ef8738a610fab8f22269bd041636f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "927a7e0e79cac12ccda96ef4c0c591c1d0882eeb2e893595ea6e13bb9e95d9b4"
    sha256 cellar: :any_skip_relocation, ventura:       "927a7e0e79cac12ccda96ef4c0c591c1d0882eeb2e893595ea6e13bb9e95d9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c1041093e74d0c825113c7e4d96b7ec914d95dd2a1179a8df853e30f3970a72"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"dockerfmt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dockerfmt version")

    (testpath"Dockerfile").write <<~DOCKERFILE
      FROM alpine:latest
    DOCKERFILE

    output = shell_output("#{bin}dockerfmt --check Dockerfile 2>&1", 1)
    assert_match "File Dockerfile is not formatted", output
  end
end