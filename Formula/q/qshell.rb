class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https:github.comqiniuqshell"
  url "https:github.comqiniuqshellarchiverefstagsv2.16.0.tar.gz"
  sha256 "84c37af331ba5e6893c3cfb3badd4dd6c04679cbe9017d74d869f2e0cfed8cce"
  license "MIT"
  head "https:github.comqiniuqshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3272aa339d167a4b758a0638cf31d184ed5901cf19b7c7b052f4d22ce5e87f9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3272aa339d167a4b758a0638cf31d184ed5901cf19b7c7b052f4d22ce5e87f9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3272aa339d167a4b758a0638cf31d184ed5901cf19b7c7b052f4d22ce5e87f9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "906d69842f4899a0cfb7d117a899ddd95189e2e91ffe8e3d5f5371d904aa5720"
    sha256 cellar: :any_skip_relocation, ventura:       "02fe2f9d6c98dc70c4ef117dde34f77a5d0087225b3750a0ea10e6fbe8b0f729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c95fb59a6feb96e5d4ddb5f65f9f485a804da843c75de77951013a87ab8bd10f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comqiniuqshellv2iqshellcommonversion.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".main"
    generate_completions_from_executable(bin"qshell", "completion")
  end

  test do
    output = shell_output "#{bin}qshell -v"
    assert_match "qshell version v#{version}", output

    # Test base64 encode of string "abc"
    output2 = shell_output "#{bin}qshell b64encode abc"
    assert_match "YWJj", output2
  end
end