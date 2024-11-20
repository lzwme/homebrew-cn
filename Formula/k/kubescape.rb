class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.21.tar.gz"
  sha256 "ebb1ca26fe598d7f7d76e76d854bc86463acda2aa2c90b6e2c29c9c943065bfa"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f5fc9362c1bc4cbb76eef54a699b13a5c6c826dd8d7382d0c63c309960b8f44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e42a43772f99c0744e19bda59a4399983b29793bb7439692948c224ce00219ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3421714fd51823dacb7f479cbc8bf5921eb590322fc58f40178dee2329f20ab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "90c4c41611700dda8611ea8ee09b934dcaaa2667c4cc6851b7a0c3f06828e254"
    sha256 cellar: :any_skip_relocation, ventura:       "83c4e8ac3bb8a8d7ba3383f643c1c333596957de8775bbe8d951d1854c566995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "649142fc82ce912eb9e25b6b62b68ad173aa88a8c2747a44be8d95d954658ec2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkubescapekubescapev3corecautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kubescape", "completion")
  end

  test do
    manifest = "https:raw.githubusercontent.comGoogleCloudPlatformmicroservices-demomainreleasekubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}kubescape version")
  end
end