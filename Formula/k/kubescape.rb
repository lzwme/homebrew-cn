class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.4.tar.gz"
  sha256 "bcff7876531c7726095ecf6dff144bc352f9936c915df105f5b803769c2a0aeb"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66af254c8cf08ffdc89a14edc2bfd6d4cbc16eb4e74d93129e8398ee2eb0579f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a4f4c2ee570552ff5cedcaa1c3c10f9cade68b4649fcb798c3c6e752c283422"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "120c2c0b603f63aa72d087c4c97da3b20a63a408978eb3e42acba1c3b80cd9e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "94fdb8a8678c3153a4a40fb65118575df5aa7d200d91824f0c522573a3220fcf"
    sha256 cellar: :any_skip_relocation, ventura:        "a1f3943a52b0895f0039c85d0e05ec788b45c1b6063cab902679dac4933bc690"
    sha256 cellar: :any_skip_relocation, monterey:       "d09505f5fe7c24e5a1fc223eba3285275b57b7ddc5f9e7ea9b6c1583c3f73f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f13bec16f3ef874cb0eff2ca5b1ece64890026503d287dd35a7b2cb22917d56"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkubescapekubescapev3corecautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"kubescape", "completion")
  end

  test do
    manifest = "https:raw.githubusercontent.comGoogleCloudPlatformmicroservices-demomainreleasekubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}kubescape version")
  end
end