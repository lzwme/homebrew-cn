class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.13.tar.gz"
  sha256 "d6554bb55265222da562dd0148647724ce804fae497a85b74a0f74bdd47e79a5"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4143ff86ed064b56f9b05bbbadea44a56bb81e8740f99e5187afe1689ada8647"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89cd645ab84e0bef3b201e735d6707099b68a4e1912ce0ab539a89fc032cc457"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd571d9ded7c6fd02ec96841b551d7595a4f6744f4944eb8b367f1017d14c0cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "254747107cf3a62470898f08ed3ff0c6882cc6871476c064e6fe5c10ae209d79"
    sha256 cellar: :any_skip_relocation, ventura:        "bc34c797758228a7dbeed8867edaa993699c2056251857c67ddaa4096dcd5b89"
    sha256 cellar: :any_skip_relocation, monterey:       "6f49e4a01be588139a4786de04320656db2ff93b5928ac6103e05fa82bf8ef39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d932f27e925fb8e5eae66f6bc80f1f366068c6a900d6cdbe32908433873b6705"
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