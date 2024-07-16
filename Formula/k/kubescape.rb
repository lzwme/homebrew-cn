class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.14.tar.gz"
  sha256 "a3e38c9c3d686bc9dee183f10d370d06941685a20c1a033056ab490bd03c8655"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eab0108d70adddb1189603d65472737715d7ac16cf512f5a44ef6aef60034768"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6f529e4f43ed4a63bd34a817c641d69e457678615a5df737f7191fc618167ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b984c5b2da7c3fe19f4f96afb4cd12d1c7d1251001d5c6aa2833a7d9e5db1de"
    sha256 cellar: :any_skip_relocation, sonoma:         "0519deb8597bb3209eb09967ea17842176bd50b9ffa9eed8cada6eadd151f6fc"
    sha256 cellar: :any_skip_relocation, ventura:        "ed95ce3d90d8aaaddb1ecb9b57a58c3c0ac215fa10fd0fee591f51468a71feb1"
    sha256 cellar: :any_skip_relocation, monterey:       "5aade1579af101a1f5b0b60f4cfb124486ff5ee786200c37084adb9cbb8d154b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04f0cb8d3282157173034672b56244ddbbe8b735f88ff16da368d8867f637144"
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