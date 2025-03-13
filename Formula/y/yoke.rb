class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.10.7",
      revision: "83aaae087595fbc3515936fe44d03827a5512d95"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f9c5fc20280456b21648725bb722c3551666970cdc869b89dea2d2107102b81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f9c5fc20280456b21648725bb722c3551666970cdc869b89dea2d2107102b81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f9c5fc20280456b21648725bb722c3551666970cdc869b89dea2d2107102b81"
    sha256 cellar: :any_skip_relocation, sonoma:        "75557ffac4aabb12f85e3b15410fec4438ca46c3417e6a42d650d5da64b716b2"
    sha256 cellar: :any_skip_relocation, ventura:       "75557ffac4aabb12f85e3b15410fec4438ca46c3417e6a42d650d5da64b716b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbed276dbdddaf836371fe7e1288d8f4e325a29150a57a6609bdab558f78953c"
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