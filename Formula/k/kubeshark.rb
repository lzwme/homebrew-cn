class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.59.tar.gz"
  sha256 "157491bcbf4f3abe1d41448e6180973537f71f074c8f0718e911dfc14c4bad10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21c3e01a3d77439b2363e110485c84c91adbfb0213d9b7e4e52b5fe95a8b966a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "440cb79fecf97d34de868191ff02d8a3a3e7394717366f76d918180e8851979d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "991a156cdcb434eab23548025860ba15a9ac1123f53cb60bb5ce0cc177eddfdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "060ad1b355766f3feb9032e5e889df23e04d147b554587e69ec2f411e26b9a27"
    sha256 cellar: :any_skip_relocation, ventura:        "b3fdbe843ae61436cfddd37fe87560f095b82db5f13bbe101f218cf807fca33f"
    sha256 cellar: :any_skip_relocation, monterey:       "0b1da55125a49cb77a620584cdc1e787b2d7e79bb1ce5e257734dec671349b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c19d4f10c5f255e86c0d767b3246af337110b042bc14a33d4c886983afa1cf8"
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