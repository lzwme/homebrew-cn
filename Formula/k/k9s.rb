class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.16",
      revision: "3c37ca2197ca48591566d1f599b7b3a50d54a408"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a885280e5a495b27e0a2f9eae296663589d362ac1a38be7284161049c15d9f28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75aa0ac8f31513323f19ec2d440cf29409ddfd6f3aff94a6d43f90f0d31217ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e76b19e7393e6f9bfb43d9c819d29f6e32cec8d89762f76764e8c5748fe2da5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c692b17e541d3a72ec3f02e1d8e7d233acd3ae3664cb3e4735accef73efe98c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "793d207a40d4c3a95a6a5a1b6c6100eea31d2119fab7d66ec5e2ba426e02bdc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0446467eb3eeb85cb05bc79d0fb466fd900cf0f5435952db2391fc2967e715b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", shell_parameter_format: :cobra)
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end