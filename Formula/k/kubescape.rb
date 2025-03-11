class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.31.tar.gz"
  sha256 "1dbf7edc998ade0ad00edd5a6e4605fe269a0fa4d1093308294f008f069cffdf"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5195af3dd42805402dd1aa2507b5023b76f25d602d9db7349390882041cfe820"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6885050e814d6ff1d3e1220b1f7cf4df28ce6fc184a9ef817fc113fa800861ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84102910f293bb79740b00e51406d8ef9e342d5c0d203c5495631710bf3bb10e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7c1f0f8519fadc8f17e321a4f6d96053e8fd4e239ecab573e90db9ec397e4fa"
    sha256 cellar: :any_skip_relocation, ventura:       "c05ce8e06b3001ff790a7933097bb5035ac466e9285c41c74ffe68dd0d50a16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4644141378837a7db819d1c7aa308170db172ef378f7bd5afd65e43b4f64c374"
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