class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard.git",
      tag:      "v4.10.2",
      revision: "376f465c111c39c6a5ad7408e8896cd790cb5219"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e751f55186e98e5418ca1b98fedb501f4221d3ac0f61ac530a776acb5c4681e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5747ad63f0c9dba4f3629264de4799228ab0d34b3bedeec9176a7682f8452922"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f90a1dbcb8cf533958869cad97f4fc7a8a9ad21eb5e2d2fb9aba5e2e0c0b476a"
    sha256 cellar: :any_skip_relocation, ventura:        "218c7be26778934394f0498868ae2638af67b0d0748c935fe23fdef5987fb4a2"
    sha256 cellar: :any_skip_relocation, monterey:       "a055b98f6809298b44b6a40f98343a55a57ff9bad0540d8c5e3e9c09631d7b82"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c50d50fa5344709fd44ef35b4ed709435d2e456c350ed5c57e89d6107e43a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "643ffc451b0b5825c31bd300652a6aa620d3032d199e90a061f919b08234c94b"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState=clean
      -X #{pkg}.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "make", "generate-docs"
    doc.install "docs/checks.md"

    generate_completions_from_executable(bin/"scorecard", "completion")
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output

    assert_match version.to_s, shell_output("#{bin}/scorecard version 2>&1")
  end
end