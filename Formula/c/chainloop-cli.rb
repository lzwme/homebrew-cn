class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.105.1.tar.gz"
  sha256 "69f4ff61da82ea646eb6a07eb9a18c3210dc09ae71af532cf7824c5df95a4713"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "901d5022136b7b8dd4ce371efa51fcdcf346f6fd62b23e23a97b826d26779f22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901d5022136b7b8dd4ce371efa51fcdcf346f6fd62b23e23a97b826d26779f22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "901d5022136b7b8dd4ce371efa51fcdcf346f6fd62b23e23a97b826d26779f22"
    sha256 cellar: :any_skip_relocation, sonoma:        "cba031963ae4988ec79b1dfa285346a2e0097553a1bcd3c36bc79260b98c1203"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7957413835c26dbb2758bfc7cdb1b50ac373a11e6637c4e6feaf45a7604c16ff"
    sha256 cellar: :any,                 x86_64_linux:  "e6de0eddc045685c9c8cea8da0970cda462fda602b9411fbc4868a16b2623462"
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