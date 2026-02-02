class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.19.9",
      revision: "ec528936bfbb303e39b51255a3dbfa3224dc502c"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08cf603f20851f7d3c5740141fa81bb2339b9147a50ba1a97b24d1324fb7798a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "981ce4c34c415be9a97bd1d686a3da548abb197d2970d0fcf43fc492c350357c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75a13a6d032770c2f87973a3fe55cbdca1d285ac69fc5c13e0579de106714c28"
    sha256 cellar: :any_skip_relocation, sonoma:        "647e1a9fe3e2eb4fbf393387a27afc659c1b4d6e8d2ceb734a722c11f2c221bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "362da3e2a1f27f718fdce451271b578fcbd0f18d0682cdca02c67d229101c621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5bd5ebef18615eba7760e17b75fa967864b7a7968de850527316c2000ac8bc6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end