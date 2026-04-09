class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.11.tar.gz"
  sha256 "8bbe442da5f3faa2df50a98354ac897c2b5a1017ca6d2a7ad4a42d16e377beb5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c833a0676679ed96e0f2a19634e08f8beef36e3ff006af09e6d1a3c46431c0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b23fb3be912ed890af262f1476ad65dcbd7cb999bded50b2a9fd779154039d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cff147b41496e112f46a7a48b276d9012cc770f09853c2bb52018f6197cade2"
    sha256 cellar: :any_skip_relocation, sonoma:        "54dd7925a83356f818323fe9435dec19b94ec9b8b914e575b1af22b7fdc6dbce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3651caa588954d11ca1321e06ce30e76c1b86e3b75259018b85d22aefb81735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76f139bb39daff7a60d9910be68f746581494bbefb7f6b5ace3f369ad0f93f7"
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