class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://ghfast.top/https://github.com/hahwul/dalfox/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "48cb44ef215d8905135e36cf27605c5a5addf3123cff29ca48e11f95c681c6ee"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e3c9a972aa3a74efd5e375b71d547e8688077c4035134a5b19b1d6130f68d79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "709833b24c1a958b4ec2d4e53800aff793751a892139885c81419932be1c3fa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37a5b50cb0b5ed87cdf32d466eb13aa30f8aafdcf63d0831857cf869205b0a2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "101d74d0af76fc598bec1f97513f244ddf1105bd9d8c0b425cf99c6c71a1b4a5"
    sha256 cellar: :any,                 arm64_linux:   "4956b02ac5acbc6a5d1562e5b6ef7e0b2b06d85b5f4eaf22e9c6c2be2a749a02"
    sha256 cellar: :any,                 x86_64_linux:  "a9e220a0cf194bd88f640925122b5805d5efe018cc78afec7f2b9c782c736735"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1", 1)
    assert_match "scan completed", output
  end
end