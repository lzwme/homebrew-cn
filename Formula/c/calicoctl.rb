class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.33.0",
      revision: "fbaa371111636a37ecc82625fce8453064a7fff2"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "285ab6442b7a97a5961d8e37198a80ff482316f6067f75e0e100b669592bca47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "01dd66361727494f7874595262756bc00cb30b3007082828c28ebf929a86d37d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "491dd29d477b7b61a6944978fff8697b2063314f2d4248ebf59eeae504654dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f45deb3bd9bce015403f653be40299f7c99e447a28b793ea9cf282abf0107721"
    sha256 cellar: :any,                 x86_64_linux:      "6ff21bcb3b90782f925423d7136543e40ae7da19191285c412b901f5c5c34630"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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