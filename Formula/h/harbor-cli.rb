class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://ghfast.top/https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "10324b3171def7a47de3bfd9a4169153162809c252a24319ae3fb53a6cc52a95"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e84f204e42b97b5bddd25bae37fb1162e9fbd975dcc80a0bef7f96bb16225c1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e84f204e42b97b5bddd25bae37fb1162e9fbd975dcc80a0bef7f96bb16225c1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e84f204e42b97b5bddd25bae37fb1162e9fbd975dcc80a0bef7f96bb16225c1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f400826defea52348d021cccc0107713691ad88c53b8b1ac7529e4567c33389d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d517c11548f1c5579e8553c6e65245b899258193994d681025f4107b5973038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "753a9f4811330dde575c4ccce57c9bd2011cf243047b2bbbbbbe6f1553042842"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GoVersion=#{Formula["go"].version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GitCommit=#{tap.user}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"harbor"), "./cmd/harbor"

    generate_completions_from_executable(bin/"harbor", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harbor version")

    output = shell_output("#{bin}/harbor repo list 2>&1", 1)
    assert_match "Error: failed to get project name", output
  end
end