class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.29.5.tar.gz"
  sha256 "88d9e476e0178b75f2d95ca483a8a98886593bb54f71dfce7404460669797c6c"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bb09f795f3309e6e3841e5e13b9a6423031147576bcfa137a55504220502ae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "998683c0642eaf918fc52947258a24a2e5d1e22e2300f61b4586c76ca251724e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1845fa4aeab6ad54a78c7d19879cafb7349ed062e68d108beed19371e26b3caa"
    sha256 cellar: :any_skip_relocation, sonoma:        "36afc98c7629de497dd800dd685c3b04031a6c5680921265bcb45b00ad3b92c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "236216cdfcd80d1b76320985f3772639113d9aee3e8dbcf32ba6f95c18f0d74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4abd4ef7708a153286f5ed8f37ea3aa2e0f1f9f6a04476d694364508fa0de601"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end