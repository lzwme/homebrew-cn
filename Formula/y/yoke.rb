class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.18",
      revision: "71def3efcdae068d0c2839ae9943d0673435187c"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3d347ad44ff8f202c89baecb3797cead282edddf84d15c30413f31835e3e11d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11e4cbb85877988ea8640445e82cdd16f7104f0ae48d13efbe6cdd400e1ace5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d873317fb7cda8a95d0b8b030a2a4dc0df739e9f1c947790b3a209eb74e2bf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "37575010fdc13b766f8c0511689cc22b85c7e0b1aed63bdadfd215427fd20e5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "888fe36cd2d61cc16a0687ff48788b96feb22ebd65c6e55035a0121ab306febf"
    sha256 cellar: :any,                 x86_64_linux:  "dc3b28f950e1a4d0f91247df7c3ddd18b122fd6b5ffdc3015e19f8e96cf7806a"
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