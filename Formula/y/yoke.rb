class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.13.1",
      revision: "49c863f88d390b0ba477f0b8e49f4067f96e4884"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33c6c593c20c5975aee6d25608931a2136d464582d6968a017196b4a7e229e5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68dee8ee61f3808ea590faf32b502e0e242d50beaa0db9d865c09b6c30422e1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3d35cc15ff3048d1dbbf6546238f16123ff7e6c35aee2cb801e2198ddb4ffc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd660a46ab2ec0b0a09ed9aeed1a7585c2d55da9bb7824356cd3062ec4eaa462"
    sha256 cellar: :any_skip_relocation, ventura:       "35aa26baa662c673dc99aa1c43b7fd77e2fcdaba01ee8ecdb4b9db1956a9370f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f908143d079130d6411788952ac8eff9e8e3f762d93c795eed236c488a357d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ecbdbe07478b9d0e578deb64a95dd443dbcd547393b69824fe50b5f4393e690"
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