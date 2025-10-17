class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.30.4",
      revision: "b370415ad69ddc139a0981f8c5c6773e4703846b"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15777d0141d030233dc7e12ee0f97334db1ab4df74e935b9eb119588251ffa88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15777d0141d030233dc7e12ee0f97334db1ab4df74e935b9eb119588251ffa88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15777d0141d030233dc7e12ee0f97334db1ab4df74e935b9eb119588251ffa88"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cc6d0bc776677789b9944e762d32350abc0bcb4039c8a3afcfbc220291dbc84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "900cf0c2fda0b264e43264a2b5430642bac1dbc6a8914136c47f2dc5c766c672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db865f9149b22dc02141ec9be1ccb4376b0fedfdf6e87048eca2e960ab435171"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags:), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end