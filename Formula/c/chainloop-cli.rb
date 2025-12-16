class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.63.0.tar.gz"
  sha256 "948c1f894606c06c0bd33317e7e1e6fce07f383e78ad9ab4c13e0f7b90a8e87f"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3e11893e08e708b00ed7053fd12c3f4c535163749a56c50f0720ae410b9cd92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aadc1659b03f4ddf53c72883693cbb1fa77eb34a3ff1d0b09f7a97162666f520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b298963b8052621f527d9f0571baa6395beec1aa77ed926904c1c6c87dd4bdce"
    sha256 cellar: :any_skip_relocation, sonoma:        "d21ee58c394d67cf3ca5b00fad8944783137a375b05be91dbfb599c193e07094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8bcca7825f033cc2abc8ccd52ffd3d96fd0c6a2e9da3437de937b33392a2d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a63c91780f81c5bd475d767dd90c73ad71ec418492a6d1d949999bc4a4388282"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end