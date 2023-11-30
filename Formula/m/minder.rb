class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://ghproxy.com/https://github.com/stacklok/minder/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "1ef89ca6a2429cd792b450c1f68f533d920c0dff224176b78b516bed58b35f92"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7814717bb58fbf5b71521b32c3edf999f98ffb68d01af17997d19f7f09998d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f4bf94aa0b0b6e3e8aedf61c13741bc25b1963dfa070298de8b073061a7353c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e822755485df887b27d8fba664b8ed708606b35a66a82562c3554a737c120ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5881c1c089e603947a2e5c200fb636e4786fcc804d30e10dfe234e1548832c8"
    sha256 cellar: :any_skip_relocation, ventura:        "1fea2ce54a58fd9521cfd7cfa768269be2589be8b0f683f5f2451788a0daf75a"
    sha256 cellar: :any_skip_relocation, monterey:       "647d2ba3f2f2dd6ffcf9fe7679631a850d33ec8e3271cc4e0f6e2f7675de952b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22c344a64b0d9ae02cc140405d28d33a02ed5a74657e607290deaf21aa430370"
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