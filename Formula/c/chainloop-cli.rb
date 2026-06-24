class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.101.0.tar.gz"
  sha256 "2b6c6346ae237e757f063461ad589e16d47c693d16c5dcca4eafdb2a07968a77"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b79fd68b3a3a5444cb5b0b862881994d3a0cc8a742a43d2f373e0f2706719eee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b79fd68b3a3a5444cb5b0b862881994d3a0cc8a742a43d2f373e0f2706719eee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b79fd68b3a3a5444cb5b0b862881994d3a0cc8a742a43d2f373e0f2706719eee"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ff8446a02e8e290c308b5d38a2d00d1eeae712e3ae46895873e799d20a0e275"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1956a5cd0f040656743434c02972b98a7e562f48abbda1aa90e6942cd372b39c"
    sha256 cellar: :any,                 x86_64_linux:  "5bac5f5e297d97db0549afba79beb3d968aa8499b7204e64d86fdf77aced0a02"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end