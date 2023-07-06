class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://ghproxy.com/https://github.com/kubernetes/kompose/archive/v1.29.0.tar.gz"
  sha256 "2d8b0b7543e00b391215585e8d550c00d65620f3788445aa057e223f1317cf55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "347d28c38145d2f7b0d8f91195b605e3197b5d43abb22fff7295f2adec15d7b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "347d28c38145d2f7b0d8f91195b605e3197b5d43abb22fff7295f2adec15d7b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "347d28c38145d2f7b0d8f91195b605e3197b5d43abb22fff7295f2adec15d7b9"
    sha256 cellar: :any_skip_relocation, ventura:        "e8de4a5ed0f0860ea1e6b9de4a1a2cbb2c20f3d144874c4c792bbc9276468ec2"
    sha256 cellar: :any_skip_relocation, monterey:       "e8de4a5ed0f0860ea1e6b9de4a1a2cbb2c20f3d144874c4c792bbc9276468ec2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8de4a5ed0f0860ea1e6b9de4a1a2cbb2c20f3d144874c4c792bbc9276468ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8826dd078f4e1287371b7b2cd6ad5d8509de1dc353e7175998cf3b8bf96596e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end