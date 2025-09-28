class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.8",
      revision: "d9c0e7cd5155a3b9148c53758c026c9e6bdae768"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3af7dffb11b7434340681956983ab67fd9ed120b1f514c5ccf523f7d1f644027"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c545d7cab92d48e19e37acd2dbb1042854b60ad17126490d10ed2eae378195e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8edc40fc8730c8b362765f22a9a7b2849136120c56a5bcf2ceebc500292e6ea5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4e1a6c718e96a1342dbef7bff2a24d977e42a41c1e0e38c6166a4abb7f885f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6db89462e2d63d3a2ceb9b47e41a9163eeb104a953c7204b43b340761c37ebef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c1bfdb28aeb23b4cfba4c9f9a02b3835ea4822167c41795f170fac0fae6f73e"
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