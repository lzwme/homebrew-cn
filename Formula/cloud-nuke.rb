class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/cloud-nuke/archive/v0.27.1.tar.gz"
  sha256 "a7b27d2c256c3623331d32c9fbc3e6896458f086817affc981c2acd2d6771f9a"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e18080f8668644f7849b05e37bc67f6a986de2b542f4d60154542d1252950802"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73b452bc7f8c2c706e7e0ef1eaf6c7d99df700fe8957aad836d22ee188b022ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "409b6841ec7565aca0695253244865f5c34d97065be7bf6cb9e9b8494c65c910"
    sha256 cellar: :any_skip_relocation, ventura:        "714edfc5fc29a2a045f57dfdf0d6628a0b7e18c3d6f2d276785f5e0a15eb324c"
    sha256 cellar: :any_skip_relocation, monterey:       "48aaac4f5380ed2cabedfe1eb11fc8f131e3635c58a198497e842e06826bfee9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bd5cd5a7b2bc7f072b68dcb593a894e6737349b227f6a54573a519ebe908133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7475c1c43a1a8541efd2c20ef5e981acf48a89469fd1da1f25195422018095b0"
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