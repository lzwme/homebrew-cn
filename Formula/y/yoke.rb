class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.14.2",
      revision: "1eea2e2c72edb193229c1cc20059a349e04700a1"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ae17e245495956106af28ef4a0133e73826421325a126c542b6eb4cc1823671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02937ecaa677e89d0fd191657f50dbbbaf467cecf906c1b87977bd8e250ce8a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b036705166870f04a4f6626b8b29de303d0f2639823875c3678187632ec3f19"
    sha256 cellar: :any_skip_relocation, sonoma:        "85291cd357dd826a87a29b2407403888aa905d3c0c1f66b51a37a23148896eed"
    sha256 cellar: :any_skip_relocation, ventura:       "619f32656b1f7818eacd88327314b0a20fba7a4c49a81000915594b6c896f549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2920c2bd32bc431707caf7d4fc45d2b2b0602bc435129ed26cfdd9aae372305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "831981bfcaeaa15efbafa35508435f254a99f65f71c331486772c1bc62718a09"
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