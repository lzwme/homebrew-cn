class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://ghfast.top/https://github.com/qiniu/qshell/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "00a61af4d8dc5907bfd96538f6c9c9c5756be86dc5cab0202692b79d2f69534a"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10f059d2b59aa1b2e4c9939e575be7cbf64de6f9ea5756e4ab0c0ae7530796cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10f059d2b59aa1b2e4c9939e575be7cbf64de6f9ea5756e4ab0c0ae7530796cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10f059d2b59aa1b2e4c9939e575be7cbf64de6f9ea5756e4ab0c0ae7530796cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae0b03af16382ca2951deb4543558757f9e463101bef1511b26570ee3813107d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb18c27ab166618f8e8e030d8648c848705c034ad0d91c54f8e5a40cd839200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "054f29d58fd27be18b916a6be84ad7e9c00536367b20ff09e5510c0ef7146dd2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/qiniu/qshell/v2/iqshell/common/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./main"
    generate_completions_from_executable(bin/"qshell", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output "#{bin}/qshell -v"
    assert_match "qshell version v#{version}", output

    # Test base64 encode of string "abc"
    output2 = shell_output "#{bin}/qshell b64encode abc"
    assert_match "YWJj", output2
  end
end