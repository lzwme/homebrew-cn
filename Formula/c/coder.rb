class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.36.5.tar.gz"
  sha256 "50bb05d9e5e0d2cba499a7479b293e620cc868c5a1f58c1314d07648ae9daef3"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02f577235038184f4ad2c33a21b0b81066c7e4e302d15dd68ca5bc78b2ac11fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e36e89aa052d371edf9af10a3f31ddc990a38453c54efce695b4940be763510"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3beb7dd80e7f4b729c888732fda28132a2fc18ceb807ae7bb97c344007fa75d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e15784163eb5cb461f20cff94fc5fa787050063dcfd25bce103d09736871341c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d12f60326544151f473b01b73b315178fa83ad1c1a0746bd47f6e343a7cd09ad"
    sha256 cellar: :any,                 x86_64_linux:      "255eb401b9f7fdd55e4e935528244ebf51e5a3849f27dbc5d198d59f93d244ab"
  end

  # TODO: unpin go@1.26 when coder supports go 1.27
  depends_on "go@1.26" => :build

  def install
    ldflags = %W[
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