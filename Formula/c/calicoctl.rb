class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.31.0",
      revision: "b1f3c43f84370504e218eb5be8a34c81348f866a"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "336b83584e2ed16a6fcd453ef30f9769c001845d7dd704604e4189566f0c8b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336b83584e2ed16a6fcd453ef30f9769c001845d7dd704604e4189566f0c8b3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "336b83584e2ed16a6fcd453ef30f9769c001845d7dd704604e4189566f0c8b3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e153fbcb33682c973cfa506856a76c287eef87a388f28191fcb98b140ce75a5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7157408c633c321162dca5cafa9d6b981e18d4802fb02b35eee75189c1ef6787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee134778550cdc7cbfed76e7897245f21e4196a9da67b72fd163da1d1337a50"
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