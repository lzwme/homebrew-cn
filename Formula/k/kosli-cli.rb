class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghproxy.com/https://github.com/kosli-dev/cli/archive/refs/tags/v2.6.14.tar.gz"
  sha256 "9b37dd362c745e03cdbf65efa08a11f880e34553401c29ece2bc5ee4152b1d29"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e1e9f73a6c6f87eba4c8fb2f99c341d237483ab87325a33fbd0dc6daf8e5c12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72fec28883447a3aec61248e4f4b29085a402d0401254b7176f03ef654f3e906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22b950466fe114b896c0d3add0521b82f0c41eff1333c4eb25fd9ab76ed7d721"
    sha256 cellar: :any_skip_relocation, sonoma:         "91a3c315356c811453ef667cf5fb07f02fff93cf0ac55df6c0db5e9c267fe6cf"
    sha256 cellar: :any_skip_relocation, ventura:        "d8610836cbf327e51cf038f83c7a057aa67c39be5b6cb5af7c72b599017c990a"
    sha256 cellar: :any_skip_relocation, monterey:       "4cce9ce3f03f4fbe61077ae519d79490150f5bf6e30a83cbe08c00c2362ab879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c614177c6c88bb4e83c186d70d8d96dd4c14ea6d3ecd174beb21cc2962b2d08f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end