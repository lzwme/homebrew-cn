class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.15",
      revision: "72ea1d48513a467ccdbff8e238396a278c3f4dd6"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d11d69ec2eee13d7194f48410fd9e0f307ade0f6725eb223c562f09fb472c1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "512cf9ee0103c47ebf5becc54a0b341aab6ff7ca63e690ff4b9fbebb48276115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2174a411c256b28af5f1c9866d57dc2ed34e9d8652e3b5d392047c9abcddc8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d2d45504675e706c727747644ac277f96ee7c911ef0378861e37b66d408230a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86c98b8f2322c197d5434d786824952939c0515e98222f350aa05488bbb00d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73559e73c9abe8b80318e9355f5baccc95a5ff3c683f14f72f6d1edcd9bb21de"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end