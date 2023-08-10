class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://ghproxy.com/https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "209618eef253c15bf2d625cb1539fbab5b9b10c342798a6159d9e515f27ac46d"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb35a28c4244c5963acd0146e124d25cde9bcb34011d307edca7af30d0097e56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb35a28c4244c5963acd0146e124d25cde9bcb34011d307edca7af30d0097e56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb35a28c4244c5963acd0146e124d25cde9bcb34011d307edca7af30d0097e56"
    sha256 cellar: :any_skip_relocation, ventura:        "2bb67ce1dd3d9092f95ba1305b50103dbacc8fa1660c0b1f3ddc92374adfb9a0"
    sha256 cellar: :any_skip_relocation, monterey:       "2bb67ce1dd3d9092f95ba1305b50103dbacc8fa1660c0b1f3ddc92374adfb9a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bb67ce1dd3d9092f95ba1305b50103dbacc8fa1660c0b1f3ddc92374adfb9a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e435448000cdaa35937fb7d108aa403c974bddb262e9219ce1a7525f5ab0d29"
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