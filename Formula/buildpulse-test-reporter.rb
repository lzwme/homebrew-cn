class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://ghproxy.com/https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "c73e269fc6df2ef3839a75a8334b9d4ad1b0997049633355400998f85cc15366"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e996f2d3706e8375f09fee0e0b6a623506e2f6ecd18323d1809f1aa8398e3ae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e996f2d3706e8375f09fee0e0b6a623506e2f6ecd18323d1809f1aa8398e3ae8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e996f2d3706e8375f09fee0e0b6a623506e2f6ecd18323d1809f1aa8398e3ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "bc06adc2d19e79b2b42c5a27c0051e993eb1c03cdcb4dfc5cbf169da9fd1cb19"
    sha256 cellar: :any_skip_relocation, monterey:       "bc06adc2d19e79b2b42c5a27c0051e993eb1c03cdcb4dfc5cbf169da9fd1cb19"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc06adc2d19e79b2b42c5a27c0051e993eb1c03cdcb4dfc5cbf169da9fd1cb19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed45018053e6d4fd73f4f72578c29e8ee044dd0cbe3e4cc2de4c8f04cee13432"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end