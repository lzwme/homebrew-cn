class Evans < Formula
  desc "More expressive universal gRPC client"
  homepage "https:github.comktr0731evans"
  url "https:github.comktr0731evansarchiverefstagsv0.10.11.tar.gz"
  sha256 "980177e9a7a88e2d9d927acb8171466c40dcef2db832ee4b638ba512d50cce37"
  license "MIT"
  head "https:github.comktr0731evans.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d1bb213d01116bdef091ca159ddeba2e97315958cfecc1526d65d67e5e29ae7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d1bb213d01116bdef091ca159ddeba2e97315958cfecc1526d65d67e5e29ae7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d1bb213d01116bdef091ca159ddeba2e97315958cfecc1526d65d67e5e29ae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "afb78ceadf7221eb37ffa03f0ad50c565085486ff3b51440bfeb9eee6e86b1d7"
    sha256 cellar: :any_skip_relocation, ventura:       "afb78ceadf7221eb37ffa03f0ad50c565085486ff3b51440bfeb9eee6e86b1d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1551ab2a16f1e6c5f692fb21f44821ed7ddbdec7fd138fb7af9928ad3d4ec62"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}evans --version")

    output = shell_output("#{bin}evans -r cli list 2>&1", 1)
    assert_match "failed to list packages by gRPC reflection", output
  end
end