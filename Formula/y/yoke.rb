class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.11.0",
      revision: "26affc2dbfa6c8d62fb65cef157d185d873dd62f"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4bd4ed114c87161c730aeaa4cdabe0c26f96bbcfed4737763dc933bb5af217f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6e89a8b0aa04f66df23788c27b5c36d1d0234baed170e1dfc71a45eb4da69eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f998984e852cbc7af52872b946648ddee7fc88e829b324be7326a60d67d50da0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9114b370fdc3386f3b11506d06eed519a031cdf92b909b9d44aaee034198bf"
    sha256 cellar: :any_skip_relocation, ventura:       "cb1e7d177c40a131e2b4c84d2daf1dfdacdc56b37c64a9266b86f04b1b406a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307940c675aa68349f3b456435868ea0ffd1f62bc24ed47bcb881e46517273e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdyoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}yoke inspect 2>&1", 1)
  end
end