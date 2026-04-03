class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "0e57a5cdfbf44ef91d9c4526a54ededad2e05d0cd9b64a109b475532012f59f9"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3619a4e66137385ef9ab73b17a45a265894b12f8e88031f52a75cc2e91a4145e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "617abf8b4041eb0c9793bbe26559bb393f36a0c198c943b2945599ec8e5c8307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58963b910f005b9fe0489870c9962afa521472379c2ee469a41b782db6b0a9df"
    sha256 cellar: :any_skip_relocation, sonoma:        "26f34164be2638ad304862eeb41cb5a143444505e62485b96a72d9f261730a65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "375abed95b32bfc3b627b4419013243636ced3e0812930f4211f5c18f014e8fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64c1113433c0c73d8ec5a0f10e28591a2a6466520f50edb2adf9a97aa40eb2e7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end