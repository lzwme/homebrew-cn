class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.32.4.tar.gz"
  sha256 "2ecacd40cafef1e5f0ef83eba263675a39c70b8327e3a01951d7e3c755267ab3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9796c62871de8018e5584b54ef5b1c3128ae5f820ba9270fa2a88e6619bffb02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba9cac9e94f00c59897835a9422a131a5f358a975e0eefb9f68cd7128e51737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dbbf710f6d6a65d8aba4ac5b65af3a28a9f79342e9ec69d59ff20b61331dd85"
    sha256 cellar: :any_skip_relocation, sonoma:        "acbe925a231b89986afd6d579b2a11d7da8050cd343fea23635293affde85688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97f6e4d3aea4817a1a5c1ab80f9d9c0d606e74672ef4993366c92848f80339f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08eed1264c16b28d393ddd63869558d4cad7d3f2425011c43cf572e002571e0c"
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