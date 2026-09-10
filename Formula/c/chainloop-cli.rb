class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.108.6.tar.gz"
  sha256 "ab68c39a2f9719485003de829f0cf2e001ecd58ec9c0ebbc43c2259ff73dcfda"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea3b591a3892e0eb491f374f92f121a41e4df476d5baf7619ca04fb87df46e7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea3b591a3892e0eb491f374f92f121a41e4df476d5baf7619ca04fb87df46e7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea3b591a3892e0eb491f374f92f121a41e4df476d5baf7619ca04fb87df46e7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c156db4a149bc2dc2ab44863f5cf28ddef4fb97570d1c54f519ff221525f429f"
    sha256 cellar: :any,                 x86_64_linux:  "07a3755e3533c9088b6999bcfc5d8301e2eac221724acab1bb9def624259ced6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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