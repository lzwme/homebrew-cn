class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.105.0.tar.gz"
  sha256 "6c0a70506900718949cafc61ac2b74397e0fbf6e57e495b267cc6d1ee5675f6f"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16db6773875a6c28c05be82140f9d67dff647d59046305f79c50aa924a44274b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16db6773875a6c28c05be82140f9d67dff647d59046305f79c50aa924a44274b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16db6773875a6c28c05be82140f9d67dff647d59046305f79c50aa924a44274b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f5d07f0b7a957f43824a3b178ff48919cc56a48960646a81ea2a8faefc44c02"
    sha256 cellar: :any_skip_relocation, ventura:       "2fccda8d01c52dd2c29ce71f4c95d648fddec344c8afd06c65f29c1c6e29cacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a872c52f5dbe905bd3dbf170cee9e21a162917c3683150302755c037c65041e1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end