class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.43.tar.gz"
  sha256 "956eab98fa32269c526e7fa136cc3551101954280ceb10371c041ffe83028158"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2fcc31ba84cc1ecd5132f1e75aea116d5acbc0da44a5a344fac96d630a376cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c2786f6561ea539c185b4c68a03d149fabf855702569d30ac1d9885501cdfaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff6ef5bb310e35186d8857380d2e6cbaf7ed89525783665b3b4b880e44978ea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b96156bbb9f520273fccbadab9f220bbd267908db795c1e128503d40ce97b63e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "929b65ab3f1fcf411f709bfa1cd1e0538a46453ec3db4dc5eb054bbcec8420d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f7a15d97ebe4fa95b218ccbbb71db8bb0904184d8cb5ec4e3f8bcd76bf261f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://ghfast.top/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end