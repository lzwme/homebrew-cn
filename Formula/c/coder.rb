class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.17.2.tar.gz"
  sha256 "eea6aba9396be756e7e7652c05b6669d683bdae4177acd578820819c9014856a"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b51cba958b16e5265eca7856b3a9a833d759c165165d68bd2e81b0a442046047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "829ab7b22e05c21867ff1d6b832e82a593bcf9a574211e180648dc4178f23646"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f23e6963db2c819d43f482940522cc4f4aeaa24fe54ee8b40673ff265d6b0fb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b552c10cd3344242f09a5cf1dc67213e39b5cb6b48ba7dcd919f6fe9b490d3a"
    sha256 cellar: :any_skip_relocation, ventura:       "3aaaf72f9144883fd73fb061693ed852ba7b56d60b7bdf388c581f5d346b492b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c899d3f16b2261f62149a0f5c6c85b197da4a89d1d423756d00d750bc98c3cfe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end