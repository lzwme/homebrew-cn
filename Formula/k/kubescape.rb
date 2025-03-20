class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.32.tar.gz"
  sha256 "4fdc00bbabf6502e124303a386470333d89483d978725c86aab2e368cd56228d"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d65417776ca15a586508ab98b01aa07ec49f69933f7a3347810727c0dea99c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ba90e861ef21041390467e445eec6cd1d5c95fb92a032d40f2536b15293bdd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "953cb76edc95b6a41889f588c74c583931dd4775e3c08feb49c65a3a340274fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f476f941f4e356889348c7aaa2169bea6cfccba417133275eed1e1977fd94e26"
    sha256 cellar: :any_skip_relocation, ventura:       "18ce310907f5d42e79f863acd66ed7ab397cd1fb1d37f7c8030baf35a9d293c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b711577d43646baea0ebbc322aa3bdfe105c691f7a95f1cfba9f3de6b95a036"
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