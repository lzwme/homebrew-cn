class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.75.1.tar.gz"
  sha256 "b723cbe2020e869ef3b5bca816ef9ac7298e45eefc773e8ce7164fd3de630eca"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4aa8ea9b86039d379345aa8a2165748a2b05b31044241e3098b18ced71eea3c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329ef5e9698f8c2b2daefa0b3cc630330f5b966a0c38b3b642b6a9a871b795e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50ee672c7e869ce092255bc93f680c020e79827483deb9316aab8e00099338f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7514a5eca14cbfa5e69d270e6b7ffd2fdb8e60e2ddbc0abcfc0a3e630749ced6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94729ff82ff74eda09b6e53e54322dd22f1eaa22ae4bec4c627786939c89cd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27f83780eeb25b002334702a67ee287c9d6c185681c2cde08e84e150b0dc1869"
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