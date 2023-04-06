class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/cloud-nuke/archive/v0.29.0.tar.gz"
  sha256 "8441b0c81ffaa3355692f4249fd095a9478ab20fb542d838798525752f32552d"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbd246ea70d9ce74ef2ee8b7551ae0b19ff1d2c7c1258104da7081e8be7ae503"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49d7b6403d22bfe1204e7e17c03f583017e622068823f43b55d318ca96228d51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7fa0cf660a96ded3f8d5a23ca94fa08c9d4490471d3d4ce05cb4fb3b2233609"
    sha256 cellar: :any_skip_relocation, ventura:        "8019a46d6b4b8427dbca12c869155a3979f371b59724f41b4ef8b38a230b3ba6"
    sha256 cellar: :any_skip_relocation, monterey:       "ea8c532baa52f1b8da74e62acc2999bf7f4fc1d2c9f7f2182842c26f8e94d754"
    sha256 cellar: :any_skip_relocation, big_sur:        "14b2a79077de605c5d8d601e3d1088f3802248ba67eba01158dce112e390fe4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf1a22c1eebb321bc5e173e59fe9fc4ac079a12be44c317dce0d07f98306678f"
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