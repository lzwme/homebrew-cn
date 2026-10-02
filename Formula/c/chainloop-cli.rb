class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.113.1.tar.gz"
  sha256 "ace7e6bd258ff766b01adc2547e421dd358517e273510dac27a1149adcf4d341"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fab56ffca8a9e7508351b024f268190180ec177124d3f2f724ddd7609f01bd1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2fab56ffca8a9e7508351b024f268190180ec177124d3f2f724ddd7609f01bd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2fab56ffca8a9e7508351b024f268190180ec177124d3f2f724ddd7609f01bd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "20c0a55d70ecd72c2277f109f8dfbadc2b59adf401c027e29a8cd18bd5b09a3d"
    sha256 cellar: :any,                 x86_64_linux:      "134960288d03ff2ec02f043bda5a66fab8e1d3014e5784bc8832570de1f8abce"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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