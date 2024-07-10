class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https:www.kubeshark.co"
  url "https:github.comkubesharkkubesharkarchiverefstagsv52.3.69.tar.gz"
  sha256 "8088520ff96687526fcfdc740633ab1c51b0260b31f9de300afbf527ff32db11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc04c7e96917c6ebf582a3ae0b13beeb8c0b817852925e64e70649e714daf99e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "373b2a28d7f83d31946a3324da946353a9e592d2476719c15aeeb0044a3edf9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76b062f9e4ddf548b71a6f037ee0089af20e62c1acc1fa647330db8ca5b30d6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1770cfe00859ded794cb1695d0f23553e0f87ee99bb471237d3325aff34297db"
    sha256 cellar: :any_skip_relocation, ventura:        "c3fcc88eb45fa823712897c14b97a2f5e78e134b7c0e82807dbf94da84c8f0f2"
    sha256 cellar: :any_skip_relocation, monterey:       "0a836f0912d0960aded01a348755c55e7cecabb84bf7a8d252ee27ea905b060f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4169900a1116b67fb76f676c2a395700edcc43fd432411fbc9a6c7063d4a7d3"
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