class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://ghproxy.com/https://github.com/stacklok/minder/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "b8a993d1e3247475a2f6cac915dcd249da360fb45c2dfa6cf834d3d399bc60cc"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6341598382281a3520b446a0a6baf80c16b0171d8db0f96c851352cb83bbcc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "add41de109be32c22f349f75b6c70aea8fb2188b4db51139c5eeb1c8b36c7ff3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99fb1656d3de9f566416289e4e490e915d2dcf9df5402bfc9ce3b0e09371c6a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3eeae0f36a6e2e1474b9e3bc5421bb1a6c8cec24b1138f866d9f2c4ff660f08b"
    sha256 cellar: :any_skip_relocation, ventura:        "6bdfc95689722d2ab8b1ba91902c44b749e39b4d407fba288d384b8f6013be9a"
    sha256 cellar: :any_skip_relocation, monterey:       "5cafba69c41d3068624f63775d9a872e8714151a46c21aae3c1e630dd1dbb36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b67a8046cd37ec3ac0ac258502f7f0c63eeece51f1d35b5bf49b4e6e5e8738c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 1)
    assert_match "Error on execute: error getting artifacts", output
  end
end