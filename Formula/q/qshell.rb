class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://ghfast.top/https://github.com/qiniu/qshell/archive/refs/tags/v2.19.11.tar.gz"
  sha256 "832aa5ba13d1d0f08062dfc008714d1b4ad4912ff31225012e2126ece38bfe2f"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8ac75268ab0be577e93252ddc02daf5375b011fd48776ca3b2c0af62304483d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ac75268ab0be577e93252ddc02daf5375b011fd48776ca3b2c0af62304483d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8ac75268ab0be577e93252ddc02daf5375b011fd48776ca3b2c0af62304483d"
    sha256 cellar: :any_skip_relocation, sonoma:        "63b97682c1af08154f4bc0ca9e9eaec9a0c7bd058558292a567f7be579589e01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "671d568f8c95367016b44d0f3911df007d1f9ff61a007e4bcbc531f3deece161"
    sha256 cellar: :any,                 x86_64_linux:  "72af27dfedbc3f237cb63bcc4089c217a527e875c2f2a98bf9b3883af90896eb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/qiniu/qshell/v2/iqshell/common/version.version=v#{version}]
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