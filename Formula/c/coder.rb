class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.31.10.tar.gz"
  sha256 "bd9de83376c27722f5095ec14263f1e2ee3c64763e32cbbbdf775f6bacbc7413"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "218f627c7d102b6e9f6932151c67856bb0ff555399e8ffc4145e7b5516e1da9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901c59de6742852bd115e2e0e69235f8d052a127c3e5725342e9897d2d25b3fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89e7c7a159e910b026804b6617e464e1b49845d966a62834a993e0bdb649578b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c56a8c7feec39254df3ec7afd4a8506d8001381851424794343a8d34d38b9ffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb83060d3957102d64b8e5cf0cc3baa7f51ce93efdd6b1de5b5ef99de08913e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa5e3978a7245eca568339bb2b660c43fe4900615a51541ae49b9f8183c7200e"
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