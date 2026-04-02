class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.11",
      revision: "1182942b8cad5c9f1c469b3d08199b45bc56b48c"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a695c3acb3410ba45ca6c079f785e3d35f7ac75cd1de34ec0f6f1ea721f7bfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d08407146d973b615fbd812bb6f2900faf4cc27d860ced0c081088261d2cb37f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "566a3e223eeca32333c262fe129660eba3516bd0fb9f51f31432cf9de5301ee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "19b2de323d69d7b2f3c0e8240e2980ea3904a3bf836a1ec9200d6f4bf1b01185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e68985aac84913772c77b2e2825cbb9d37ae7e3cac85d040c8316e98ce429d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "819b9c1d66c2893c36d0dcc55e315b4d9adb757f34ce990b3f956b9b2fb637f5"
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