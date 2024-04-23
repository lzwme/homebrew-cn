class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.50.2.tar.gz"
  sha256 "a83c0eca1b201a8d93bf865ad9ae35c52ac471148ae49b0e73e72934354b9962"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd3fc8d16e855cb5342e1ae96c508125885e48e4b3bfcce2051405f8c3b6c48f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10e92d17435e5b1d17fa7fa7ed5f94317e39fa87980423ea4cc87d02c87d7303"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85d437e829cf7db9e658d57e78c0ce9ef7d647fafc954a6d43eef0f7e6c4e88f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e302c1376f946ea499a62fa6636db3056f876fd14b312130de0680a4221ccfc3"
    sha256 cellar: :any_skip_relocation, ventura:        "a6f23ec70a701b5b15babf3dcb17cc8ac52c0f7912cdae2fe7f61a83b2f5d1aa"
    sha256 cellar: :any_skip_relocation, monterey:       "fd1598e50ed3310ab4581aa634339fe7a829e526e03281070323c997dd96623f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8b786c54ba6ec608726bff6f502ee5cb5560bdeb895b4917f5f1fcf142b7448"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversion.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtrivy"
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end