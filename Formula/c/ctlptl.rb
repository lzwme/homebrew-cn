class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https:github.comtilt-devctlptl"
  url "https:github.comtilt-devctlptlarchiverefstagsv0.8.30.tar.gz"
  sha256 "d4f1cd6cba0dc0c5ae9125e999c0a03aff08777db2b581ffab4ed6e3a41b8287"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab12dabb797101a65579cf479a122e1951f5c01393645eb1e0a4652411bba317"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9f6197354f6eab421151a370de55684ec97948dd140743b152968c8d62b1657"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f8abd764ee2a5fffddf3229ae8f114dd89ecffc91438adc9ceab7d99155bbf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebfb155d0977e935bcc1197cac20916dea8988d3ab4521e152d425e4cda376ae"
    sha256 cellar: :any_skip_relocation, ventura:        "92bafd05e06d13cb8df4dc35bc1d31d0e7db928d3f9d0565484ff4017f33a752"
    sha256 cellar: :any_skip_relocation, monterey:       "1a79aba1a5814e85b84da28379519825ce37ccd27edba721575a575ed038fad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cca0d102afca6ac3486c0af13e7bbee7ce79c6423525ed25131bada945d0fbe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdctlptl"

    generate_completions_from_executable(bin"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}ctlptl version")
    assert_equal "", shell_output("#{bin}ctlptl get")
    assert_match "not found", shell_output("#{bin}ctlptl delete cluster nonexistent 2>&1", 1)
  end
end