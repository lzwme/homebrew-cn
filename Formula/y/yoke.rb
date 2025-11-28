class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.18.1",
      revision: "53ead188937fa2b6677c0230773dfa1c992f3688"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7289032710ff74872a5930e477589c9c5b93d2225c31072292e69cdc684c66e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a91df514e99f443ef011606c279a2d92207ccb56e180e8906d83a2b9deaf7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a771ad3b2a4523deaccb81127b64f53c90b2d33fe9ee8f96652ddce11422ea9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "044845730ad2d2192e1569ca28f5efa6da9f43ee05af59f89ab66b7eaed00e8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa9ad6dddcc07123681abb15df326ade9a14b66c20e8cead021b6da421e71ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa667352e5d739336cb80c81479759d9b1ccf81117a69ccd281b49a66be45bdd"
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