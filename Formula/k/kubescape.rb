class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https:kubescape.io"
  url "https:github.comkubescapekubescapearchiverefstagsv3.0.23.tar.gz"
  sha256 "cc541a3547fb67ec3af28c2ed5f8cb1ca5ced9fa95bab3d4fc66ca9abe7e9015"
  license "Apache-2.0"
  head "https:github.comkubescapekubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e853580815799708f8721bac1d870cef839f9fde84a213d16db55d4f1dae4fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49aac4f69d78056e5c046ca09df29b16468b82b84625d119aec7895693b4f87a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c842f2a75edde84f33c7bbb7e32e27a48d3d479383a136955ccdb273dd94223"
    sha256 cellar: :any_skip_relocation, sonoma:        "13fdda479157023c150072d779d5d91242275dd363871822d4dda1ec70c44154"
    sha256 cellar: :any_skip_relocation, ventura:       "5253003fed1e26d881373bf5e354bd2763463b854c597ecc82d189ff6abc271a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0e1ad6c332706061f473f4320a16a226412a3e7127097df656f21589bbb332e"
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