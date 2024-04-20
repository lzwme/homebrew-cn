class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.2.30.tar.gz"
  sha256 "fd0af9cb4c080866481843bd147905b4d3791a3dd1c80970404b3260a232090f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30af2126ba92a84c11a030b80accc399cf3b806cabb4b9a2da7512ce4841133e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32069866c31dfd3eaebe6f04989293316affb4c08f9361b7b9dbb9f954d76c72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85ee8866dbca6835c9ffe2beaf4b1651bb53e8446e42b4a11459c7e0ea7409f"
    sha256 cellar: :any_skip_relocation, sonoma:         "612ad80baa760a2d6413d7e5475522be63588631bac6d18674542859669ffe88"
    sha256 cellar: :any_skip_relocation, ventura:        "7fba129c8716f67d5228d330c3b947ffe7635a3cc9b43d0c6712b4f782a3355d"
    sha256 cellar: :any_skip_relocation, monterey:       "06e8b909d9015c93e66886bf9dc186c54136a4a9eeea920666e05970ad2ce892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "691556dabad7e7450ffdd658e49bed772648547a91a30d4a3054fd4baec39db5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.comkubesharkkubesharkmisc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.comkubesharkkubesharkmisc.BuildTimestamp=#{time}"
      -X "github.comkubesharkkubesharkmisc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    version_output = shell_output("#{bin}kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}kubeshark tap 2>&1")
    assert_match ".kubeconfig: no such file or directory", tap_output
  end
end