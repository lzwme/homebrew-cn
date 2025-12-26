class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://ghfast.top/https://github.com/Azure/draft/archive/refs/tags/v0.17.13.tar.gz"
  sha256 "577470d72285647e7a85a3c4c18d3bfe787180b36dd79ac86f2dcc1aad348708"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af0a442d8caf116eaef9b3313172865ff47805f46b7b69a50abb52074208e205"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d41b2f2ec5c21b70914773a759268bc059d654b0da01b2d9e912c48586a3c177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc3a3e0b1344fe3229a1d040739d7e01d0c24d817554e6e29b390fff44f01d52"
    sha256 cellar: :any_skip_relocation, sonoma:        "6684f2e37b3e787101ea51ff84941cbd0395a9bd99ed41025eed50ca9928c6a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36db0720f7a0c5f3d0a1001151f93d4626d18e55d70a955350f9991c7b74b209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ca516655ed3e8e31fd18ad1a56f77957c0d3aa43851e93998935c7640f5b3c2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Azure/draft/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"draft", shell_parameter_format: :cobra)
  end

  test do
    supported_deployment_types = JSON.parse(shell_output("#{bin}/draft info"))["supportedDeploymentTypes"]
    assert_equal ["helm", "kustomize", "manifests"], supported_deployment_types

    assert_match version.to_s, shell_output("#{bin}/draft version")
  end
end