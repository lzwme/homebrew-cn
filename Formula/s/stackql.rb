class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.509",
      revision: "57dbab7d1b66ce30864d480de6843971aafe87ff"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e365c852620c873ce65d7f3930e4853006abb38bb9109cbd1ebf5721fc5ae091"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "593bb18eddc35dd0d60a0418ecf75f93a87d106225577c0416ccfdcd372e407f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba017eb4656a0eb52f210d5e8c8c3f5dc0641a9b7fdfc37baf4ce25efb4057cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "34434fa0b8e4dcc77af68a79978c7f0b4c4537639609c37739df7ff063ee5bdf"
    sha256 cellar: :any_skip_relocation, ventura:        "06852d303de5102709180b31a29ee3afedf82a96bb11a102fd21579ca10603e8"
    sha256 cellar: :any_skip_relocation, monterey:       "f5f2bd3ac7505f9af17e33ae93532a3a018c3bbd82c969609896bb877a512cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41cc2d9437a7e1cb22a3c4b824bfb6e4a86f1041d399b4911a986a795ac537ea"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = [
      "-s",
      "-w",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{Utils.git_head}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{Utils.git_short_head}",
      "-X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true",
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "--tags", "json1 sqleanall", "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end