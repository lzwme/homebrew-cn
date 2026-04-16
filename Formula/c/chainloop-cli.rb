class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.93.0.tar.gz"
  sha256 "082c008bb337bd4f44c7f7421c4d97046a3b9e0aff8f58ff26fc93feb9e847c2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98cd011621c654dfbbbaa4f5c81cd2cd62400a3bff296a80f9a0264bd7c3a86a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69495c0d7ee0786ebb061e9e8314260e1ede78f72817f6af7b10a1c0c5613a94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "112bfcdf44eaef32371fdfa300cb224226bb78b789cbea879bd84097522570bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d7573dd3508e4a4b274399aa42f5d3cc421d240b3f9613c200fdbf38dae8b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a8db9c3d9d3f7c0437d49a15e055b6f53ffd0da650db06897b9ec9f747e9d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6814da505b79e72c241badeef77360ccc30370835ed4fe3250263aaf8506145f"
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