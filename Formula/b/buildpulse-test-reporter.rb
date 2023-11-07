class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://ghproxy.com/https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.27.3.tar.gz"
  sha256 "90e3b70b281f00bd9473ac46d089778ceb9c8e48c9cc2a3b42e850e440162c31"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4a2374b49edd5dafa85c5ef7eb698dd212dd5f376e7948631c574d0bbb3aece"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4895f34b1411dc0a18ae2c459972f3931ff91ac67ec79e7f3f6ec08e5056ee90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9de1035145027b7d7cb40bcfe940807f3ea7c3cd7a016cd85c35450f43d2fcc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "00e2976a6690da7438bb36609f3563e8e0b62124daff47b0711cf58d31bca5ad"
    sha256 cellar: :any_skip_relocation, ventura:        "95d1c6e0f1d2f96fe695edc5842f16fca4c5d05f09c620c3a57c642626dddff4"
    sha256 cellar: :any_skip_relocation, monterey:       "2bcd63688954d517d22768d68ffca44951d3d3894cd794165efd11104fa4d554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4618df6bc6611505554d7c9ee7134405a9d8224e244e991a2804fcd21db25d30"
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