class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.31.1",
      revision: "7517d28a5fdb00ccf57088353c82862aad43e710"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad5668f092a7b589bd4ee6ad2ec81e5b002f64365c0e573530da86ea35710ced"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad5668f092a7b589bd4ee6ad2ec81e5b002f64365c0e573530da86ea35710ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5668f092a7b589bd4ee6ad2ec81e5b002f64365c0e573530da86ea35710ced"
    sha256 cellar: :any_skip_relocation, sonoma:        "1037f0ad470d18cb6c7e8087e1212f7fdbf06c7773c8a444bf92870ad4aae4ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c4db845cf98947b47180d97c0198f766be44de2aae5ff37a63492176cf381a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6a38bc56235bc75cf124e206397a5e2362472197a958ad10b584b4f6c6762a7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/projectcalico/calico/pkg/buildinfo.Version=#{version}
      -X github.com/projectcalico/calico/pkg/buildinfo.GitRevision=#{Utils.git_short_head}
      -X github.com/projectcalico/calico/pkg/buildinfo.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end