class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.27.3.tar.gz"
  sha256 "17615dacaa041629e352ec2a92101447208f5c702830435fa5e762d04efde681"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f18c686b4dd99c5c5485c6ddc288d9e9b9b8ed5da17aa8d4cc468adc17630808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dcda3ffc166d46825e9d1283848f670f9ea4ed70cc5422b238f60fa993bc296"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40c59129fe5e018d9d600747b6eaf7c9807e26725a70092366a82c8cec32a922"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0d60c269c73628bd93565458842746bdb1adba6daa3ad8ea332cfcc68359ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f168adc79e316b7bcc021d7e09b738a3e222c191b4547ad51c66c69182de5c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89afee1a44ac61499967849ba622903254565c43fd396a146e7a29d3c67e436b"
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