class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.22.1.tar.gz"
  sha256 "66fbeb2510d0df59fdd2dbbf47cf0ad3c270016d33003da74df85bfd539420fd"
  license "AGPL-3.0-only"
  head "https:github.comcodercoder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06ab285bd406383f630ece42a6ecff0ce781f4feb6586cb2fafcdaf960acdd3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "292d1676dc09f861c4088743d3a1f3c6cc2deacb8b9fa86fe0516c7e5a024361"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e69f8a5099a29528b14b31d2113f613158d9f9b78b12870bb9b386b28a2a2d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "34006d8b8b2b3c715828e7ca16d4c6236c2645b6a555475e5fcbc6ed14c58001"
    sha256 cellar: :any_skip_relocation, ventura:       "6a1de13102403f283f323751318e5d5d1e065b4a561525e772e1ec288f67e240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4065d6704febc4a19e0465a0dd33cc16e0f048121b11c358df0a0ab0a21e5c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9793a9164265fb213f257226d0c5cd5bc5c401a966011c9603491b374b902682"
  end

  depends_on "go" => :build

  # purego build patch, upstream pr ref, https:github.comcodercoderpull18021
  patch do
    url "https:github.comcodercodercommite3915cb199a05a21a6dd17b525068a6cb5949d65.patch?full_index=1"
    sha256 "ec0f27618f69d867ecc04c8eae648eca188e4db5b1d27e1d6bcc1bde64383cdf"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end