class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.17.tar.gz"
  sha256 "f3461d9c00e1cf2fcffb325bdb8b43181662208b618a55fda45ab69925b3ee88"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "424f3dbc876ed534eeb794a0c358e57256498722499fbf9a1f330d32c0a22c71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d69007c529f9f0e60619c5b6a03d9a733fb4c966b8b21881be67f309d2b35ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a5654111c0ffd3241375df4d172dfb7b75cc99e9dc2779d323e835b667bffea"
    sha256 cellar: :any_skip_relocation, sonoma:         "6178332b370a763c69212055bc274c069a46a96c0e51ea67605dc7dc25c9193b"
    sha256 cellar: :any_skip_relocation, ventura:        "8aa3b4ec2153a3b9c5653e09ae9d2ac8caf78752d731acb66970d2798b75b1c6"
    sha256 cellar: :any_skip_relocation, monterey:       "d236644957342ad7f05bd858df7a9f2469b5438a91b9244f055d76adcb7b24af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f91c5d98e5676bcff1d1df4c2bccf542e1f79db60f90448ae60e3e5d234677"
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