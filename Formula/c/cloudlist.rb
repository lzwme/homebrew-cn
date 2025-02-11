class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https:github.comprojectdiscoverycloudlist"
  url "https:github.comprojectdiscoverycloudlistarchiverefstagsv1.2.0.tar.gz"
  sha256 "ca726db484414c6c8d38623ce3bf7b52ac344a0857d003dcf62bb013e5f571a5"
  license "MIT"
  head "https:github.comprojectdiscoverycloudlist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3603d58866ccd9a0b0e0625a91fb77bc6ff74722ea29945eb4e9f96f69c80ef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b15e6be6075f52717f26193c5bea6c26efe18c9255507462693a7510a61a1d6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6630873e1d85bab1610eb37cd4a019043ac5095028d1a0cdbd0796cbb1c6807d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9143db06bbdb9db9250235e1a46467c2169b06039810c8a83f73af69d6a9bb3b"
    sha256 cellar: :any_skip_relocation, ventura:       "a8406d19b3ca0949f8111097c0c8e1f54ee2c652e823074fa24fc28802892f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c0709663a7c567f42394a40206b9950c86c5098ddcbab5316d2bf39f6b4a05a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcloudlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cloudlist -version 2>&1")

    output = shell_output bin"cloudlist", 1
    assert_match output, "invalid provider configuration file provided"
  end
end