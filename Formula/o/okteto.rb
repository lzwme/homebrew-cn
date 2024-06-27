class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.28.1.tar.gz"
  sha256 "9583f59799301e50590a3983bd4bb5cddf69556621c8a2a2e50aabbbb420eb68"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccddd082fcb1a8039acc6a670e096fd3c2106785d33c6d8b8b85ae60a7617a0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "200e42550857eb63fe6f8c57e763cb7e4627c84068fac9129348c2e9095344a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb6983eb47f7e2211ab9011e7601dc25ca3b3727411fd5761165576375008191"
    sha256 cellar: :any_skip_relocation, sonoma:         "85cbb1c912a1d2d6692edfc670210cebffdf7f48c384f50f8d536085a0a85d1d"
    sha256 cellar: :any_skip_relocation, ventura:        "f937f8e0755da662009300869c2e58921c36d6fbf322874e2f7df3670f034e44"
    sha256 cellar: :any_skip_relocation, monterey:       "b6269c05231a2c119c7485dce9ed55b0473a32168ac7bd7002cf4255e45234b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db09d1393801befa410748cab79dd57790141a4ca33b9ab665e3359dde2e240d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin"okteto context list 2>&1", 1)
  end
end