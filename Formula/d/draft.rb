class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https:github.comAzuredraft"
  url "https:github.comAzuredraftarchiverefstagsv0.17.8.tar.gz"
  sha256 "4e1cbda04d9a188ab70a897575902a01a7e2b27b64f9db1039a7cf80c5de7788"
  license "MIT"
  head "https:github.comAzuredraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01d8ba139d211166e4573eb3867f3c1cd6b33ebb19dafe29d8eafe56ec90055f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "358dd51f7d9b241b69424f3ea4e13d6baae6d8e988027eb9728ae2375022f71c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1931c9fac97e5347bcb21bdeb6c71a75578047b36128eaa9285400fa9fad513"
    sha256 cellar: :any_skip_relocation, sonoma:        "70bea0b2fbeb41dd6a4af217bd6a12660f1ab866a322037e4f6f30189ffc0628"
    sha256 cellar: :any_skip_relocation, ventura:       "2149b2484b9815a2f76b7bc31e174e1563447e8c588491695d6770e93488baa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd571fb294360bc41ad8d506e6eae4708328127f7851edca00d144b3ade12fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bc77b077601de7573c07d1720621a5b010fed7b7aab7661780592a0da6ecf4b"
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