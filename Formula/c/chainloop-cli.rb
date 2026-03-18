class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.82.3.tar.gz"
  sha256 "04173f0116d95dcb98bf03faafa6d11cb7f9c23f2a42b73c6164e0361a225168"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25d1de47ff7b8de84f0b48f64ea9a10ddca63bf57b1cca3c90e818718985903a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908ff9d2bb9fb8ae00cddcbe14c66c9316755e6f6b36e2cce59538d072390566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e290598f9f72395d2b860de9f0ffca307f3b06c1c9001bb0b9300d54c82ca21e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b68c159f2ed514028e4bf91ff26ee051fa4d78c6d40ee0d0622e2eb57e7c602"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7511d1eda5fe49dc382b164cbfbb01fe1ce26744cb5bc045e29f26d203e2711c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69611faa55c3a5f93786f38de89d65db77bd6c536a5c88c2867a870d55154d49"
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