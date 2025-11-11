class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.27.4.tar.gz"
  sha256 "ed006d2241bfaa2a754b93c51941fb813ee1758de94a176c31068872d38dd7da"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dd9326c21f87f441bc1a247f45611718ae86ca1397edd8902238824bc30e425"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d64ed9fcd77074bb7c8d9b5de9f7b9d4d76f701ce3e0cab329159bec8a934099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d096bcc0f84e83ba756017201806b5b6998824a1265c9a142dea64f06f5135f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7da873b669230bd52276e97ec1b5d8209a02de6738a1c4365abe39114b03571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15e3cf3ad496d5100da61ba0d22d3718bf5b84733b9854b059e5234b27f62fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "763bd2ee42b2a611adf2869b40219e93c664d5768887f0096822217df0efe8bd"
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