class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.11.3",
      revision: "27f594f147d868c256a4535817b186b84cc3a62f"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87d038e7d8875c701429fe6cde023843ea3e8aa9807aa9c65a75b079504ad8c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28efdbb569b1efae6dc7bef57c0e3276b9a5023c31904e76097b84c667821651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5011206a6dc0ba4aa5095a6ee57c28d004d213e1521f236f79070e9b47a1b1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e8be861129daa20cfd9529ff2a377225e78a897102dab6ade7b015be0baae3a"
    sha256 cellar: :any_skip_relocation, ventura:       "6d42f5d9656a6587e125f7cf0962bd039f42d1f778215102f1a250653aa1f47f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c49245963ac4096830490e2069b56ac108b75a425d2d8f3df88d1406e8d6612"
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