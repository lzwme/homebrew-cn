class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.28.tar.gz"
  sha256 "547d38e7984c1e299ff898ddecfd85c66cc13d83b85e6f2011daf1cdfbee26bd"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "902714f25b21af2ae6d6ba9439b9db095a97a432c29f879f661764b265ca0976"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e2bc9c6b5beae9d806e121ec08bc5e80bdc5130d45615b7d83ab3438be3e6fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "420af050dae32c1d1696845ac03e766d9c1d0e775d73bcebc74e30aba7fb269e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1979f24eaba43108ac632e49a412138b42844fd143d646b0025b094fb8c7577"
    sha256 cellar: :any_skip_relocation, ventura:       "f2afc081c99b3d297429603524e2ebda46f18cdbced75822107139a89bcafa4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbcfba6818aca65905f300cb73faa7677131ddaa1e75873d42948c6e2b9e2880"
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