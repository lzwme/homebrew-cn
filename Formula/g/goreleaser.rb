class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.15.3",
      revision: "cf89dd527b5f70b02f6295412637dbd3cfa29d62"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27e66e6547c25df209c413e776bc394e2c1a902de1b931c46d709a3e74c55080"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e2bf4833f170c3c73f11b2a9d70024e394e1868dc012e477a8c1fe349e12e9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaf11eeb6f9ab8331986e851e2b32d67d87f92286e6f3e47df9f3dec4ad62584"
    sha256 cellar: :any_skip_relocation, sonoma:        "f439de0bec7c513561beffd2aa9e4d01903cabd941f8ebba8426b60f1e407a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdcc8d0f223aba6ce6a6eed6959476c86f1f3e4b2661ef811b433589cb8c70c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e07179c2e4c98e2564ac48c2c5ac64d8d9cd256294aef56f23054c4d8681011"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end