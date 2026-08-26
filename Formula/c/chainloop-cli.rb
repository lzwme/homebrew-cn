class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.106.2.tar.gz"
  sha256 "121eb423f01fddac654324f26ff5c40dbc2794f17de63c2222f46b732f1c3ac2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b8688d9f35db5543167462279e1f45b82da820af42111d9ed373267e072b311"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b8688d9f35db5543167462279e1f45b82da820af42111d9ed373267e072b311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b8688d9f35db5543167462279e1f45b82da820af42111d9ed373267e072b311"
    sha256 cellar: :any_skip_relocation, sonoma:        "54bf7b583567554c4a5ad87e2ac85a087eade13972cdb3a8198809bed79f6238"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca6b6bae751b20afd7e8901016612d0225faee274a010174c57beccd33c72aaf"
    sha256 cellar: :any,                 x86_64_linux:  "887a63d86393f0330859eb2920be4e21d7582bed13508e33f9a0cd0f36b0fbfc"
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