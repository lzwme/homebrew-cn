class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://ghproxy.com/https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "cd0b3dfe1992d1a680cadc363fcbcbda7f67dd7b4789178a4425e5cf0c4ba961"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d19d7259228925e2cef5537a7bfbddbe8b96eaa29d668a57f3f67179ff025e08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d19d7259228925e2cef5537a7bfbddbe8b96eaa29d668a57f3f67179ff025e08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d19d7259228925e2cef5537a7bfbddbe8b96eaa29d668a57f3f67179ff025e08"
    sha256 cellar: :any_skip_relocation, ventura:        "3191e5ce1871c1ed6c47d560c98f6cbfc24f110abc15d6b97eba7e3d6b5051f8"
    sha256 cellar: :any_skip_relocation, monterey:       "3191e5ce1871c1ed6c47d560c98f6cbfc24f110abc15d6b97eba7e3d6b5051f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3191e5ce1871c1ed6c47d560c98f6cbfc24f110abc15d6b97eba7e3d6b5051f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca08692fccecdba2dcdeccd0e5daa5a994132e7c602893226f3cb74545bedbf6"
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