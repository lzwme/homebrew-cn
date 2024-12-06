class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https:github.comAzuredraft"
  url "https:github.comAzuredraftarchiverefstagsv0.1.0.tar.gz"
  sha256 "6d2af9f9aa42c027e30276c496940038b8d56b1bb4693a5cfe26f3c6a722060b"
  license "MIT"
  head "https:github.comAzuredraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc1349f7fb11a43abe44a9f2327918ee4cf7a6bce61a1eeb5f9d1d8c3812389"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5291d147090700999e68c2e72504c7a80bd6367cc2a651c0de4e123da882100"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "703f8dccac67247f061dbe0877a1ae7b9ddaf4c7304b70f867da532de64b8983"
    sha256 cellar: :any_skip_relocation, sonoma:        "00d727565b0d8937e817f3f3e98089982b70a6227e4e965e737006964a5f8cf7"
    sha256 cellar: :any_skip_relocation, ventura:       "0e8e9b65c2058675aa9802a2ac17e82d7d95a97dd1e343a5cda03b39176f1151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18c5f5bab7862fe08dd84f28c6e9030d592ed984ed75411ee5f242e1a9210aa5"
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