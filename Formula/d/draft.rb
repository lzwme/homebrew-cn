class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https:github.comAzuredraft"
  url "https:github.comAzuredraftarchiverefstagsv0.17.5.tar.gz"
  sha256 "b7cfea40e8ae0096c564379429fb9e36ec23b507781e7e656b67afab31b776e5"
  license "MIT"
  head "https:github.comAzuredraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c0634e54f70cd95842fe9032c1b3a9b585837b5f4ff5109590100daabe7166f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f77b12874dfbfb43383bbdf9c7888b273e91e0cc7ba71cddaf7a5c77ca0aa6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5aca6b0cda7ce6aace0fa220bb91c6d1f232669f5274ca5575a052a7a2e5ad16"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e1c8539d0528f150503a5ca649ec8c944ed8876af5d7fd0f91261c8d66661e3"
    sha256 cellar: :any_skip_relocation, ventura:       "57ea6eb04c7d6293b758dbc46064f388ceb12e774b866bd84be7ddf720fc9426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "239b89ca35ad11858dade7d8a592c84faa4e4704ed63f1e789d6acbd95ebec69"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comAzuredraftcmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"draft", "completion")
  end

  test do
    supported_deployment_types = JSON.parse(shell_output("#{bin}draft info"))["supportedDeploymentTypes"]
    assert_equal ["helm", "kustomize", "manifests"], supported_deployment_types

    assert_match version.to_s, shell_output("#{bin}draft version")
  end
end