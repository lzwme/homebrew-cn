class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.10.tar.gz"
  sha256 "267e4cd23d60b52b405a1260737b3ef9ec5534f49b013d0ea4f595081237e4a0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c2654be8d19711259762410725d726d8079b35b50feb1ffdec1227ae182b45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19c2654be8d19711259762410725d726d8079b35b50feb1ffdec1227ae182b45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c2654be8d19711259762410725d726d8079b35b50feb1ffdec1227ae182b45"
    sha256 cellar: :any_skip_relocation, sonoma:        "f683da5babf31ba152c2b45f22b4d2b8f3398db8b7882695de4ef62a10962fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0868333e2cbfb934977361c6c44e27c0cb4bf17d97ca6a58ce90c7d6ce9e5fce"
    sha256 cellar: :any,                 x86_64_linux:  "39687d24b042c46327db8039d08ae854b34fc2b556729e14f746b909ac5b0be4"
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