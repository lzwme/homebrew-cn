class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.98.3.tar.gz"
  sha256 "ff25130a21f20960f0be65a840461ee5c10744f97a138c605c727ab1070de172"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb6aeeb08325c02646c80858de493e83360476ae08563f895fc7fa20ad702e06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7688ef6e8df95b450e8e730ecd5cf31a407d299ba003757140f94d819ae31b5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39f7ac10df55136c99e36a4c5ca03dba6faeb114c3a4c1ecef1248d7ac6cb66d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2032c4a7d4e14a43904228733e05e7c48972299c993f3573da9227116356d7bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd69d1121a1ff4b1219a14c3c19c15507f3b9153e35101e93b0444e1d9a3d5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4ef252b74b73c75bc926d532709af3bfe4908e85a42333943c47d7dd2bec9b5"
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