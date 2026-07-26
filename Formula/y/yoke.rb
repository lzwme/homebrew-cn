class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.23",
      revision: "ea46e3eb70f6af3e1127d9c0f9912a18a6ffe26f"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78ab38207e8d03ef141646d8a60fea950f3492e384a33fc8e130b09e1a80209f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fec16f2ba5c9369bebbfb1aefffaa3cc0ec1cabb37f12fe9a829186165db543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3db5700d18a58d554f10bb0583f5bfa51ffbb4277e8254eb2f2776e5f40f1ad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0809fddd11b8d8406c71b8fddbe37b062b52c44b03156d8cd8d3dbb0fc4c8cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60761ef12ecca35012b3cde1b3e87d4efd51dd165134161d6efae4c5fb89668f"
    sha256 cellar: :any,                 x86_64_linux:  "ea86099e47b19893cdb723dbfeee5ae577c2b3b5657dce937ba50d024f068846"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end