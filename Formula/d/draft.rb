class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https:github.comAzuredraft"
  url "https:github.comAzuredraftarchiverefstagsv0.17.6.tar.gz"
  sha256 "3e7af81d5dffddb6464a2d72a29048ac2b82aafb8357a4fcc021aee3f1b1986d"
  license "MIT"
  head "https:github.comAzuredraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f16389c57172f9802cb5f8c7b54975030d5eecaa1aa233bc2fb5c00017c5560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc523c15acc278e1ce353ad0ffac064830d87dac534219ad3feda938530c60c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06770369754f6cadaf96ad557834cf19c498356ff0d39dfc27837f78844cfcc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2730363f5e92aa9a31d50ce237444e60c59b00f450b48672eee1c5d9d265f17"
    sha256 cellar: :any_skip_relocation, ventura:       "0524c35f39ace968b57f058b962d8caeb1634c495a416431dd8f53ab1c45e295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4a6fc595cc951c84b5c1f12517ce046254ba83d794df19349a01dd7d4adee7f"
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