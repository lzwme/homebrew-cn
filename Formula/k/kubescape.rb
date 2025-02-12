class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.27.tar.gz"
  sha256 "5aed36529a502111c74cde45742fac0351e6c716b44988240871164baffe3eeb"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a236f8a7df21dccce136e3432a5e456b3aba32c1cfda4ba5e589fd29d86ef5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "449e52b1aea9a7f9dd0dab55183d8b0f9e540b27ade9903d0a0319c66502e5cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a34be25485a5b3578bcb520ee7a51c37d8bea3d6cfd5d26e9565275c8142c9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "db6316fb902d4fe8ce008a7554f89ba919b3a25e82ca34b00650a41707f0a2f7"
    sha256 cellar: :any_skip_relocation, ventura:       "5d71021798592d82559cb8a85d542f2df6d57c0f2b7f7041e346ba2a6a4fa994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b4a1bca41616676f7507a941853273153ea102721e90011e2e2edc1a5af98f8"
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