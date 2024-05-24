class KubectlRookCeph < Formula
  desc "Rook plugin for Ceph management"
  homepage "https:rook.io"
  url "https:github.comrookkubectl-rook-cepharchiverefstagsv0.9.0.tar.gz"
  sha256 "19a633b4ab2f4b7ff70f5574fbec724025a373c27536bd92f0cc1ec2178e0cd6"
  license "Apache-2.0"
  head "https:github.comrookkubectl-rook-ceph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f86170c9f4a041d898abd6b32fb8d76e0a395dbd13aa717769e9d0429fe2aec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f55bfbe7be522b8b5118ba8b52ec2bc9edd148158e40d1da840e3a5313196c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52668ae3f55e4daf93518cc50e346af793934a207e1041680658663756444b43"
    sha256 cellar: :any_skip_relocation, sonoma:         "84ffa08dc21a971bfb8c1bdcd1e289a7c1e9654ee1e67a3dc67c7b3447b95b7f"
    sha256 cellar: :any_skip_relocation, ventura:        "be38d75ec35d43e2f61104305713d6be47bbbb76297dadccfda3407d73d06857"
    sha256 cellar: :any_skip_relocation, monterey:       "a1ebcbf9375878ca8589c3b93a9d567699aa84e2c03d655f5c79221f5ec918db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deb77c0c6473345d172bf3b638c95da4732bfbddb5ea719a54d227b3f9d0b2c4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: "#{bin}kubectl-rook_ceph"), ".cmd"
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}kubectl-rook_ceph health 2>&1", 1)
      Error: invalid configuration: no configuration has been provided, \
      try setting KUBERNETES_MASTER environment variable
    EOS

    output = shell_output("#{bin}kubectl-rook_ceph --help")
    assert_match("kubectl rook-ceph provides common management and troubleshooting tools for Ceph", output)
  end
end