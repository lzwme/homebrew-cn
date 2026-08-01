class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.105.2.tar.gz"
  sha256 "7e2bfb5d0cdf00a4f625e5e07ce25fbd4fee43e2434037e590799bfb9e99c41f"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21b640ab6205406324c9470560d1c3a06a0e3c506b16baed653a560386d34d05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21b640ab6205406324c9470560d1c3a06a0e3c506b16baed653a560386d34d05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21b640ab6205406324c9470560d1c3a06a0e3c506b16baed653a560386d34d05"
    sha256 cellar: :any_skip_relocation, sonoma:        "72846684f406608596d4a226e3c6eb36e958ea50c70c54033c573e320743ff70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b84d201c056f80959cd919f38485793505a1afcfad211f08df8d0c1d9a14599a"
    sha256 cellar: :any,                 x86_64_linux:  "4b9b0f887d5819301157c6cba07e4225e68e41be5ddbc350697926fa3a6ded08"
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