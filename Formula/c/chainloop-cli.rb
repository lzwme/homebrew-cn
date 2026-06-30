class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.103.0.tar.gz"
  sha256 "37ee1d9d533f93d4098f27b6509a031094e32d9c8610e2676f3bc9e99b11eb66"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3c14b7f9ebc6f6b0e7757e9b99db0fcb91478927f01c1cc1440f608699f49cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c14b7f9ebc6f6b0e7757e9b99db0fcb91478927f01c1cc1440f608699f49cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3c14b7f9ebc6f6b0e7757e9b99db0fcb91478927f01c1cc1440f608699f49cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a249b35fb48b29f5b483f660f2420bcd6dd584251bdee35cc54fb15ab7b14223"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b58d85bda847b1d28e9606b4cdb0d92942caff3f556a9464ff72e98159c03af5"
    sha256 cellar: :any,                 x86_64_linux:  "7a11b6f37f58142f6955f4503800d945aefd03668a4d3dfcd26646259b63edef"
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