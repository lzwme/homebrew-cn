class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.77.0.tar.gz"
  sha256 "25ed50238153078999301ec17a7a79d494587bd0370559d4d35b0a44d10c3ad7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56948ed6e626fc05d974612f98f4aae7b0c3156f242a51703412aeba8c392801"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b6a661d8379edc727fba8062ab00d71b51e992a4c0eda95d80241e162a3bdd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd4d859ae12b69a3b201ba37c64bec8e8d88ce2d72fbb6ded4a675b3af69f871"
    sha256 cellar: :any_skip_relocation, sonoma:        "872d3a2e77c050c9d8bf2435923fe8c510ca9a8a21b09967761d8af3737eb5da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f542a35615f0685923a0d4bac8356522e92de9eb9c040a81345f5d2f1d5e2a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aec35b17b3ed87891ad4c4599b33b784c250b2b282ada7557a5891e217c0ab4"
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
    assert_match "run chainloop auth login", output
  end
end