class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.109.1.tar.gz"
  sha256 "3e15add64a6a0cf93d6b52bff1ad03c0152a6e9c15686b4057dd08dffd4c3ea7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9bb9dbb0e8947647e74a38b4e1eb22ddc1f3a8567eaefb7625367534f9739e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f9bb9dbb0e8947647e74a38b4e1eb22ddc1f3a8567eaefb7625367534f9739e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f9bb9dbb0e8947647e74a38b4e1eb22ddc1f3a8567eaefb7625367534f9739e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "72175002c788679847e7a23661fe5021aac7f4f34fd6129db21d654c463cedf9"
    sha256 cellar: :any,                 x86_64_linux:      "03281a89d78fd468aba0b96ecf0cd76eb82e8ac38b34dc754046d691f791bda6"
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