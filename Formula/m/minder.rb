class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://ghfast.top/https://github.com/mindersec/minder/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "70a2830e7c06f28c7f71e9d5891b77419a5475c01704f5cc0f7b738a29ac7847"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db1635d440654b1318d5ce3e3b45e81932e5bc5b0f9e67a709838f244853655f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5724e81b2fdf495d8ead978af75f540d7ec0ba29520d11e90b428ad252fd4f70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af357c2543ddde355c5a52846d43576a9c9d26893f1e029158cfe8886107206f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aa67875e4ebb0e836312d02bda1216a229825844a4b3454dfddfcddf06e5c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a00e6d41f120a6f6a0b7c087096e10a4c0b202d1a18cb85dc96720c3c6622e6"
    sha256 cellar: :any,                 x86_64_linux:  "cc95916bdf741791a288232eeb24626dbaa8e7967f357bd8701e4482c024b0fd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version 2>&1")

    # All the cli action trigger to open github authorization page,
    # so we cannot test them directly.
  end
end