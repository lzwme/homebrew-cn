class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://ghfast.top/https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "2d0e13a1adc8511c4d12145bb4b7d006bd1af2a66f41044b4b89e37f1caea889"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52861a5c3f9ccd87738af97eb94f2282473e75751e99002c04d42d9fcd3e03be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52861a5c3f9ccd87738af97eb94f2282473e75751e99002c04d42d9fcd3e03be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52861a5c3f9ccd87738af97eb94f2282473e75751e99002c04d42d9fcd3e03be"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e80923c9aba1e1c492fb74422f2b3452cbd79d229b125f827ebfa9a9f4f717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cd637d38038f6c08cd2d77e79b83e1c830780cd6c03cd07e1f89801eca17330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "817197e978add271a7505eb0e3d58cf16f8a1d5f3caeb46b0ed923a28359a9b9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/rshdhere/vibecheck/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vibecheck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibecheck --version")
    assert_match "vibecheck self-test OK", shell_output("#{bin}/vibecheck doctor")
  end
end