class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.105.8.tar.gz"
  sha256 "39e76cc07a1b615333064fc0e0a3ef2ed2adc122275537846d31cc3d7d061a0e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37aa03b892976b1dd48f76648fb9fe9902c175a9f99aa636f305d4842d8666c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37aa03b892976b1dd48f76648fb9fe9902c175a9f99aa636f305d4842d8666c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37aa03b892976b1dd48f76648fb9fe9902c175a9f99aa636f305d4842d8666c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "50761baed89534d908392bc29aad35ab8fa9c46ee5b174891d1a820daaff1a66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50eeee0c05b1d7ad4391c0fc91f03803c33b2262c8514228549698be1373e264"
    sha256 cellar: :any,                 x86_64_linux:  "46d4393a29170c76617f08d6dbf258ddb61ea4cb0c354eb0184e40e35d67d9c5"
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