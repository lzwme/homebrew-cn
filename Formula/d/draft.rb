class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https:github.comAzuredraft"
  url "https:github.comAzuredraftarchiverefstagsv0.17.4.tar.gz"
  sha256 "f2f17afc951bfdf195dc6051a9a9d920b2fed348a0423e350ac624aae2a8b94e"
  license "MIT"
  head "https:github.comAzuredraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75dc410bd15c8d1875b9c466931f56ef315dea98835f711d7aa870a8dfa1519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cae665ea01226bce45161e859e3ea0630b3d0595cfda62e6eefc853dbbe9df7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5c2f361cddfeea870966da6b5651cade0a23e2bda03830c1fa7a1af10feaf68"
    sha256 cellar: :any_skip_relocation, sonoma:        "d45517912a7f82d7242b23132605b94333205debb8542bf603a446d4a9be9deb"
    sha256 cellar: :any_skip_relocation, ventura:       "73699740260ad71533c137edd19975398a0fde0ed27134c36fc5c82de8366376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57414db9983b14a2b3a578184d0b11d4338c9bb7145c6f8089281e0efd9a5b0d"
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