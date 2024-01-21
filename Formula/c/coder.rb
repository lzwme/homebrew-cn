class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.7.0.tar.gz"
  sha256 "33afd4359d778af41fc3f04af402227c6409011862679fec10bc8c84e0bebdf8"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6159008022303e0f5c5dff4979b5de70ee2e2c66ac9466a40266589a49e1a11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c2d5ea2704fe046c27714b0e8371c17909120927359553daa73dca3c528196d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b4b7d867bb0a11e5e24052f3e9b937e0e2c8da313b1500634fa5463902e585a"
    sha256 cellar: :any_skip_relocation, sonoma:         "891dd8fee352a3805ceef8cbe254f0296dacddeaf5de100775a2fb789a69cf68"
    sha256 cellar: :any_skip_relocation, ventura:        "35be154e88506e28fa3edf2711d5a1b73bc467f80fec7aafb1a215cfaa8e042d"
    sha256 cellar: :any_skip_relocation, monterey:       "634aa891ee3d3dd7f610138dc1cb91d0e4b5cff3fc22fca3975145cecef7d760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bec99d615b9f6be021ce01e9ad25cf9dc62153ee918955465d0af78cabfcda6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end