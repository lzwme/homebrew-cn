class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://ghfast.top/https://github.com/qiniu/qshell/archive/refs/tags/v2.19.4.tar.gz"
  sha256 "04c0935c5231eddb5ab0a72b0f50aaca9569cb7b2c3e5d2f515fda96d1c084c9"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c08b8ea29f5e92f1c0134feff848cc4a184dd78056628c884a44af6e92ef2e19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c08b8ea29f5e92f1c0134feff848cc4a184dd78056628c884a44af6e92ef2e19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c08b8ea29f5e92f1c0134feff848cc4a184dd78056628c884a44af6e92ef2e19"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdf6535c663bd0d1a1c391c1f4507e40058805937bdf94078b3210d32ac45d00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "197e1ff7b5ebd63c56d9b21aad6197c186e9fce734660a7e024c7326b5746027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e69104a5648ce8e6b8a90d2d9234ba82da11bcf0ecf5f9df7d9dc09db1ac8ca"
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