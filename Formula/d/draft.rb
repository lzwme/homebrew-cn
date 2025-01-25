class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https:github.comAzuredraft"
  url "https:github.comAzuredraftarchiverefstagsv0.17.1.tar.gz"
  sha256 "7f0f6714f873d82ef8bdf75f8713b9105838b41cfe1560853a3abcc3eafe8865"
  license "MIT"
  head "https:github.comAzuredraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be322f6223aff7b1e244f65d999045f294d87a5b4412b0701fedf579bd351826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8924627512e36aeef3f35e19a4c8d42897b96790a1e2da5bd056b6ea65e5f7ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1613cbcf0385d87f085050f9d821676ee370ef926f840d21f6817c497756eae"
    sha256 cellar: :any_skip_relocation, sonoma:        "d895dee889f88f0dac05c3eeaf4305fa85561473fae677ca1b91b6c354b90f79"
    sha256 cellar: :any_skip_relocation, ventura:       "5442920b21186709ff576bbf43febf907d0d0aba8de66d10c6080416b98d79e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e2342dce8522ff17574a1340c847bc6f7aee944c20529d93b1216406894485"
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