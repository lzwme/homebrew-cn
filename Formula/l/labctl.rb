class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.70.tar.gz"
  sha256 "bef58a3aa371ae74f487637dc356d6a19182e2c13b249bd9f8d8f6b1cad2c395"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b42ff2553bccdddf907c8f61f878f23ba627c5ff270160e447bbeb329bce961"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b42ff2553bccdddf907c8f61f878f23ba627c5ff270160e447bbeb329bce961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b42ff2553bccdddf907c8f61f878f23ba627c5ff270160e447bbeb329bce961"
    sha256 cellar: :any_skip_relocation, sonoma:        "caf3a9cbb3e56f7346db21091e75a66413b69b54dc854eba2e209e5112ddd952"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f60e09cbd8b6081f45076b3c82e2e3d6aefa0fc6b5c692641f9d864e0ec2a5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b24194bb869aca7e9f38188f608434fdebcd51beedc0f02e1499b76c102caaa8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end