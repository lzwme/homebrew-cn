class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://ghproxy.com/https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "aedcdae37d1e6d761c587d4cf4fb5ae4742f52ef0c69f176e77362bd50f77af9"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cf0ac3a02b755ac3b12875ccf3aaf5effcc3a586495b0aa1b68386e79b88698"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cf0ac3a02b755ac3b12875ccf3aaf5effcc3a586495b0aa1b68386e79b88698"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cf0ac3a02b755ac3b12875ccf3aaf5effcc3a586495b0aa1b68386e79b88698"
    sha256 cellar: :any_skip_relocation, ventura:        "abced10b45bd5558ae41eaa3bd3c936b21c64d57de4b725dc22d3693eca5436c"
    sha256 cellar: :any_skip_relocation, monterey:       "abced10b45bd5558ae41eaa3bd3c936b21c64d57de4b725dc22d3693eca5436c"
    sha256 cellar: :any_skip_relocation, big_sur:        "abced10b45bd5558ae41eaa3bd3c936b21c64d57de4b725dc22d3693eca5436c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d315dc3655acc50c7f16e62a38e6a30ea71e23ccded2b897844a87fd3749c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end