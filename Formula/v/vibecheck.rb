class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://ghfast.top/https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "86a54b1b4aa2a4aae87948c79f8553cb8965541fdf5911acae31119b172b3147"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "281be3291200dcb9da5cebdeace8c547bf79c2b9695262cac761c7b2a99a71cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "281be3291200dcb9da5cebdeace8c547bf79c2b9695262cac761c7b2a99a71cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "281be3291200dcb9da5cebdeace8c547bf79c2b9695262cac761c7b2a99a71cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f9fe2bdc26e6457d9f6edc48ae7b74a63c67ffcc94a16c6ef3a010980435fde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f9de4c25067cd76a8872b7adb94cf5feda40b345544d8fcaf34a46351b18f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cc188048e5f3bb36e85b1965f6816bdbfbd7a7ee389f9402be6d47d74acfbbd"
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