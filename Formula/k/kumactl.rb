class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https:kuma.io"
  url "https:github.comkumahqkumaarchiverefstags2.9.4.tar.gz"
  sha256 "50fb1880d8b6262f23c4ebf9408edecdd8ee4557f500b2e1ce75de07cb0cbf94"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48997430169713c40fea4f15be35a946b89426ca13e86aca1948d00f9b7958f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48997430169713c40fea4f15be35a946b89426ca13e86aca1948d00f9b7958f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48997430169713c40fea4f15be35a946b89426ca13e86aca1948d00f9b7958f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "25cadcf193cfea5aea278a857c0f5ee05a66b7424ad36c45942d405acc44f2d2"
    sha256 cellar: :any_skip_relocation, ventura:       "25cadcf193cfea5aea278a857c0f5ee05a66b7424ad36c45942d405acc44f2d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b947a0edb876e05abb4c6c3ca2d206c1325e32babfcbd23e305292139f5dc8c5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkumahqkumapkgversion.version=#{version}
      -X github.comkumahqkumapkgversion.gitTag=#{version}
      -X github.comkumahqkumapkgversion.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), ".appkumactl"

    generate_completions_from_executable(bin"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin"kumactl")
    assert_match version.to_s, shell_output("#{bin}kumactl version 2>&1")

    touch testpath"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}kumactl apply -f config.yml 2>&1", 1)
  end
end