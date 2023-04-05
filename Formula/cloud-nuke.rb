class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/cloud-nuke/archive/v0.28.1.tar.gz"
  sha256 "3fa279a24fdc0b76de5ac8d2ec57125727d43a5e0ebbfbeb1081b0df68582820"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3a12c59b28309dd0480fc9bbc6f4531077d37c870c9c853fa490b336a35e33b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be8c293f2d38d07e6d2d805ba4215e054fe402e9f0227907645ae89575515ee6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d43be3398fef651471dfb108229563aeb729b89a6558a425ab11e7b55ada5a6"
    sha256 cellar: :any_skip_relocation, ventura:        "8b7ed1769ed757a32d2996f175b0f0e12da52a78f0cc11feb0974d8cb1f52a1f"
    sha256 cellar: :any_skip_relocation, monterey:       "52c938ec508e54cc466fb174cb4cb7ca57d8780f162cbb73d7f3f6b74b358493"
    sha256 cellar: :any_skip_relocation, big_sur:        "716bf878c03522319b2f3e01772c9d3d2ef26d6f0e8d777c610e3d4945b75ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36a90711d050766483a93f45f92ce2fe7d10fbc3b15fc92656925e1f61b0fd9b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end