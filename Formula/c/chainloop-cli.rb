class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.105.0.tar.gz"
  sha256 "5ec15478d6de582aa8daa3df303e20cf57d638acd0059e63b764ae856f977f09"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b048debb4503f07b32bc388214d02c8c1cd948488a2364cef63c3e235a26fa30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b048debb4503f07b32bc388214d02c8c1cd948488a2364cef63c3e235a26fa30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b048debb4503f07b32bc388214d02c8c1cd948488a2364cef63c3e235a26fa30"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf224099153029b050464a078f77427c538c1d7b2d750e38e6017d7832bf7c65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4ab1df4c2ced87c7644749a7307de603838fb9a1f9076d4bdf6643adfaed99c"
    sha256 cellar: :any,                 x86_64_linux:  "2328639b69b42fc2be3e7f48e3fd7b0a7af52ed4e5fb409bcd8ce159560d2324"
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