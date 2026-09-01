class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.108.0.tar.gz"
  sha256 "54ec685b22cdeb3f2ca47f8ebae360b298e27248f48ed38fc1f4ef286822a8ad"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae7a7c09679cab6baf3eff6fac989f22f147b004eda907b7fd34ff5b1252bea7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae7a7c09679cab6baf3eff6fac989f22f147b004eda907b7fd34ff5b1252bea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae7a7c09679cab6baf3eff6fac989f22f147b004eda907b7fd34ff5b1252bea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "030d14c2218997c14d341cf120dd58f0dc536307bbdba40fa4430e5f55c16780"
    sha256 cellar: :any,                 x86_64_linux:  "72d4dcdfbb9ec3b1fe1194bdf1f0bbc589e4c9c6331b4eb6a108603570b11881"
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