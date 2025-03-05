class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.10.1",
      revision: "664422a1f563c94379f9bf6a2ed1f7f9a8eadd95"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "056a61119c8ee4cac70913fccef84d5afeddc8ba8d69cac07548281b8e209f2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "056a61119c8ee4cac70913fccef84d5afeddc8ba8d69cac07548281b8e209f2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "056a61119c8ee4cac70913fccef84d5afeddc8ba8d69cac07548281b8e209f2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa65f099b77ff3d27a250d3eb9f9fd31ab82256f363e93b217a117e67b17446b"
    sha256 cellar: :any_skip_relocation, ventura:       "aa65f099b77ff3d27a250d3eb9f9fd31ab82256f363e93b217a117e67b17446b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc4ae1ca0902d902170625fe25d67b836505b8ec331fb76c81ede0c80cd8a21"
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