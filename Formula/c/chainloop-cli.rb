class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "ee61899a2e8d3913ebcacd3580804818af40dbd017eeca8100f80087db696d86"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f7d23c37aa0525f752f05579eec7e924e88dfeb76d22544561dd9545705d665"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90a7cc0389467d7f5bbd61394f7c25ad5c3eec4c6bc3bd1b3f7daf5281b91527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58372eeb1d4bda6db9b9f6672d06a7df87425a38c1f2bd8f260c9593efebc20b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f97615bdbe12899fc6f351e72d17b99c96237e060a66039d1c57ff7743437fb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba8da16ff0f682e40e339f5e3c864c93e7b92e3f744822950bb73502344d60c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991bfc1428ae4a473abdb2db757da03e87ecedc154c4bed78727191614e90946"
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