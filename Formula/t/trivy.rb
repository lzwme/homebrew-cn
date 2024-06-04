class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.52.0.tar.gz"
  sha256 "d9ae1bfe86abe0e0f9ac8063b972a60d02e38a9ae9d4ac7e17108d32fd69e652"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5818d7497411906c5cb7b027115cc3af65705b06ad18ed89f4c2f07a06e67478"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc87b125bd48940216ea4f0b2371ec9c3cbc45a73e20fd59e943e612c38a8593"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88e64951c2334fc4fb89b08aba076a8e941fbb4f5362d44fe78f69f91f134d25"
    sha256 cellar: :any_skip_relocation, sonoma:         "01eeff0fecc04db44757e874a31c01a9b33471615bd874d09cf72337ab3ebe76"
    sha256 cellar: :any_skip_relocation, ventura:        "1ac7f92ba1b7f4494302f7937babc6d5f2e6502dcb7d5653b8696b3c575e7fa3"
    sha256 cellar: :any_skip_relocation, monterey:       "23deb14219bb8d1aedf2b83eeedbb7a71ca717bced89e74b063d3bfbad15017c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9bef82dca5544cb68ab2354c2b0392bcb19ee0ee5f4413ff7c0334c6e8662c3"
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