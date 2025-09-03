class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.40.tar.gz"
  sha256 "3c5ce77e6e7db5b186581d1c6f6e75110e950e9eb2510e02b01bf574fc704149"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1a368d7b2e2648cc418e045e1592fb659bf9b4e00f38c470442a0a092f4bb64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cb2d7399bea7413b7e68161c47c0abb535606165560e7f094185d9d30cded2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "136247fbc9990992036a4fbfebd3ed6bf5e45a954f2402ffca5034dc0466a5a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b4a3cdbc25eefe4ff4933edff0599e7da8ca1ba3a50f1b60b41a90e5f300d29"
    sha256 cellar: :any_skip_relocation, ventura:       "e7dbefd7461456fbcb796f5bdf06d52b7658071deb215f31bf0a705f4329769a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f68779e68f014983328aef3ebb850f349dfa93b200f625797b905662486e64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b89ed97c01902c9be2c4d2251514fa87ef9c4c8feda188dc850749e6118676f9"
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