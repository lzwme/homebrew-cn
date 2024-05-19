class KubectlRookCeph < Formula
  desc "Rook plugin for Ceph management"
  homepage "https:rook.io"
  url "https:github.comrookkubectl-rook-cepharchiverefstagsv0.8.0.tar.gz"
  sha256 "b007bc9e971c253da53023f0448f82091d8dc94f8081789cf9b889e86d364a7a"
  license "Apache-2.0"
  head "https:github.comrookkubectl-rook-ceph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "137aafef7f44b870db83ea59e6ec3913f293466aa348a16361520ae32bfdfa9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7d720d137fa1d79e44238cc55c4debc7bc6eae7124b8a54c6f0e21fac5d8b9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e516a225665fe3853348ce567922a513b5244ebdc6db7faad7dd5711ce2825"
    sha256 cellar: :any_skip_relocation, sonoma:         "94b05708cb60cb8cd982f7dcd169447de9de19a22a8d7dbb9054cfb98bfe9f7a"
    sha256 cellar: :any_skip_relocation, ventura:        "967d6fd4ebfff15f1a3375fb1d80b0eee5282626b7dbc7a65d55aeb570b06aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "4b19ce5f72c20d6fe2aa814e129d4ac589d771962d77db36e98e26f601628b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "218a81965136436f67253efdf2d8db8df45f1924d09b26567eb1b5868483e5da"
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