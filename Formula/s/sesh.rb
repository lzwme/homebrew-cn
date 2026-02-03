class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://ghfast.top/https://github.com/joshmedeski/sesh/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "e983542701b8c7998f046819e00f04a6a57ca5e3db6fa02891cb6ee4f6dd3b52"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a9e5d0123a6ce91ac4beac8a858d75b01a87149776a0bdace5e7a4cf34c7b81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a9e5d0123a6ce91ac4beac8a858d75b01a87149776a0bdace5e7a4cf34c7b81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a9e5d0123a6ce91ac4beac8a858d75b01a87149776a0bdace5e7a4cf34c7b81"
    sha256 cellar: :any_skip_relocation, sonoma:        "b413a71f9a19ffc2be49b59e24c6664525d3c6da467f5a0bb5e0a4af4f194a62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ee36121a573119d70d10a5e2370d3451cb1edb362ec45cb186af88bf9fde760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f740f58b310d86f2deb72bb90cb79d228956d3b1152f2799ec2197274a218735"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end