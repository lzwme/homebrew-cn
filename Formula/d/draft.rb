class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https:github.comAzuredraft"
  url "https:github.comAzuredraftarchiverefstagsv0.17.11.tar.gz"
  sha256 "91ab1bc877883e4bc2bd0424f748e2ba8b6c5e20acec52d3061ebd68706956dd"
  license "MIT"
  head "https:github.comAzuredraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaa730301a7d77c4638927be72b648b9c86555318873ba4d03cec5152e5ed710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac732690e8096ce8d836ff10c46867529373a8450530977f77b0751639df4c09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6441a7329f77438daa227cc746071742bb4ae2594df338ce59ee4bb9adcf3074"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cb28c0ccd6b48aba8e49c82a56a7e223514b321ccbc8c8ce1a597281961b85b"
    sha256 cellar: :any_skip_relocation, ventura:       "f10aaa049dd8739890b5b26d6b0fb4f771e816e34b92e9d70553d509f2a1fe1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c81c7afc2efb7f0513b0f1763bbe8b068ed22e8ccb1234f42482a310e233ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d654a7f06ea0e4cc21e9a25930c33b883835ccf4d6211d231dea39c0e5715d13"
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