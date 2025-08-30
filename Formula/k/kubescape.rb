class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://ghfast.top/https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.39.tar.gz"
  sha256 "ea365492f0e1ce0b121429454fe68dad541a3d1e791a7639106d4260fdaec37a"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb864d16cebd7b0aacf70420ee0144b17b4d6fc37c4a75b26936af07596d712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d6896bbdba20ed39bf79e1b7d468b8e4524dd0090d4e5ead34550303244fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "052586b4bdda037649c72e718998278ec882e0284b71578fbe6d8ab43eac216e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a986d3f55f5c71f5d93fd41801431b3e6b306d863d984643f31c00c252c5913"
    sha256 cellar: :any_skip_relocation, ventura:       "5af4da36e70c890c06a33177dfe99ea7a007d469ce2e4f44c8dc242b5ce30e80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7f2b5b7d72b90e033374d8237a119a300202beed7bd46c79caf0e53f5fee93b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3cffb93529d5bf3fb8753a35246bb200161e8429164d81c8be1aa7339595918"
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