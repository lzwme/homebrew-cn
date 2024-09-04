class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https:github.comtilt-devctlptl"
  url "https:github.comtilt-devctlptlarchiverefstagsv0.8.33.tar.gz"
  sha256 "7b9263a7ffde464ec11c783a1e6b3df72777032871f49c43dac862e7f78c172f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dee4a006fbd8b1040950a3639ecc3fb503e6d58dbce6f6a3c193261bf2fd120"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d372c3ad0496e1d503cb5e132fe5e774541a94ea8ee738e5498e8b927b249830"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5ebbc0fb35e2d641c68dd1c9ee9c9a7babf787b38b31a0e509e198d0d670025"
    sha256 cellar: :any_skip_relocation, sonoma:         "491eef956cbd614f3b2f5b54278ceeb7743589d37e55d4b9179256acf457a22a"
    sha256 cellar: :any_skip_relocation, ventura:        "20db5aa1a2b69ecfada14d0c57b9b7d03ed7af439965360213326ece30de4858"
    sha256 cellar: :any_skip_relocation, monterey:       "93cb83f60901363df8817cc8261a1e3c1b46df12bfe299ef0b84464ea25d318c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d5253cef47113ab006953bb09cbbbd55ac4e1a287084ebc7867e83b07e407fa"
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