class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https:kops.sigs.k8s.io"
  url "https:github.comkuberneteskopsarchiverefstagsv1.30.2.tar.gz"
  sha256 "7e70dd6cc80d0e463befa7737c4770165c21952f9e325fcd605639cec1d1f8bf"
  license "Apache-2.0"
  head "https:github.comkuberneteskops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d7e0bca137dd055e5e67711194a1d7ec6f000dbb9a92b284875eac7dc80d2d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5daf000c09e5fe875f764abcf6d0f67074d71605af9d3d11dc42d6d4f68c1252"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "512214fd94d673bf351f5cc8991dd59332918603ec1f193b0388df0522e73d43"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec5eb5d017356a0061401e4d29d447e533e78494f7c41b1c6eb9cfb3044f35a1"
    sha256 cellar: :any_skip_relocation, ventura:       "0d36d075467cbde82f3ce96c197a9f678c56126018304e5a59abb7c4a584a5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1eeddcc5d7afd830efbe1bba06c77a14c3846d56a315160b2b01895774d1f88"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.iokops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.iokopscmdkops"

    generate_completions_from_executable(bin"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}kops validate cluster 2>&1", 1)
  end
end