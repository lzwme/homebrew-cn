class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https:kyverno.io"
  url "https:github.comkyvernokyvernoarchiverefstagsv1.13.0.tar.gz"
  sha256 "c52f137191c918b4d9566c85da542aa581e4b8169f823cfd38039a44f897bd35"
  license "Apache-2.0"
  head "https:github.comkyvernokyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca47483418e3651539a5b279ce3f0a258d0674920e6174c3538ec2b58f89cbf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0a4d6d49984ef1692f4d3234471a26c011b3632ca2eca54913cc80a633099c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d72d772a835c7a693bbafa98ada776f121ab062a44466c25885a6890a723f27e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c11d8c109534299b937a3046896a201e02c55a426eecc1c99e7eba1202e1912"
    sha256 cellar: :any_skip_relocation, ventura:       "e1660936a3994af321ad767a1dd619937df7cf2ab3ab90553633e92939a5d0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3993c6efd2759b4f61c5a0d357a3c9d3372071c81e83b5c8d3e59c079a6f7f21"
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