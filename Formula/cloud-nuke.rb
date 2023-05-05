class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/cloud-nuke/archive/v0.30.0.tar.gz"
  sha256 "6aa4ca563d9ecb0bebfed214b1239e87d92ce306acae8176ac65c823c07e3ecd"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e550ac2b0f31a381fe2d5a4f1743de5af9d0e87c831b3e843d65b8b1cd86594a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e550ac2b0f31a381fe2d5a4f1743de5af9d0e87c831b3e843d65b8b1cd86594a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e550ac2b0f31a381fe2d5a4f1743de5af9d0e87c831b3e843d65b8b1cd86594a"
    sha256 cellar: :any_skip_relocation, ventura:        "75457fab698a4686869e13bdce3cb722c86a3763f61deaece7980adfacb666b2"
    sha256 cellar: :any_skip_relocation, monterey:       "75457fab698a4686869e13bdce3cb722c86a3763f61deaece7980adfacb666b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "75457fab698a4686869e13bdce3cb722c86a3763f61deaece7980adfacb666b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd8c08fb67d8dc76e7051a52074c543c1360985e7299771a3370274109bb3f27"
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