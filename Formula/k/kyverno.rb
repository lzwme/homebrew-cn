class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https:kyverno.io"
  url "https:github.comkyvernokyvernoarchiverefstagsv1.14.3.tar.gz"
  sha256 "bfde9fd9943719b94bf86d625a0de89163fcf7b83a2af38b76938671b6b59cec"
  license "Apache-2.0"
  head "https:github.comkyvernokyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3133404eddee0a39e1bf95eeccea6c5366e767cb6f450fb47402dea9a59638ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0034e9ebc8531a4d586afc5ea27010d7c1d2c9afe309466e72ca6cd92deb730b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3bec6bad97d62cfab2f69a74b735d9aa03b86a5e0fe5900f15460b3c04165ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "eed762becad492ab5c7af8f1c76382009e9512200c805d1ffcc6b7257b69de8b"
    sha256 cellar: :any_skip_relocation, ventura:       "54a65904bccad50d44f5e06f04f6c3d6c729a95c70e4cf72c259bf5ba292ff89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d129a3a6bb43bd6b29d50db1cfe50065d40ab28c10c946a9716aa19a5dc854b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5b839a8c964d68bd8583a22db9edf929be15c10f352dce9d7aa4814a363af1"
  end

  depends_on "go" => :build

  def install
    project = "github.comkyvernokyverno"
    ldflags = %W[
      -s -w
      -X #{project}pkgversion.BuildVersion=#{version}
      -X #{project}pkgversion.BuildHash=
      -X #{project}pkgversion.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdclikubectl-kyverno"

    generate_completions_from_executable(bin"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}kyverno test .")

    assert_match version.to_s, shell_output("#{bin}kyverno version")
  end
end