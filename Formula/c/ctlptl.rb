class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://ghproxy.com/https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.8.24.tar.gz"
  sha256 "de5c597b5b05c414332d54b93472cc7a7dd207d58b1d02a6cbeace460a01c786"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f6274d21d20a6fabb0e386b857a26024401caab84ed83dbadb997ccd8932639"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e867067a0f72caa61ce84021187c0aab7f8158f66550184fd51dd2377803ec1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8c884fd25b743b8d4ecd87ffd8680718a1fa5e263ba61e83024b67339188ded"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e8c3ebe8246c01cd97c1b217b356e8169e74c108c9d0b21001f52938cde9341"
    sha256 cellar: :any_skip_relocation, ventura:        "43e3b3dcbbdacdb906f26e7910fa6c85fe756e8a8d90e67d57e810d933721e75"
    sha256 cellar: :any_skip_relocation, monterey:       "2a9e19a156d89d0ad5e6bd99727ea72022946f613dc4ba46a001ab1d8bab2c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db907881db0c15de2a0b0d22211a0000a5158c8fceb6a1697eca869ff29b98f6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end