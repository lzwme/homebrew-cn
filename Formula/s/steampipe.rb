class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https:steampipe.io"
  url "https:github.comturbotsteampipearchiverefstagsv1.0.0.tar.gz"
  sha256 "1db1dd5a05b15fefeb51cd2e5b8c4f9d56dc95a25b10a7821497a728ef253274"
  license "AGPL-3.0-only"
  head "https:github.comturbotsteampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1013bdbdf24ebc49c278ba9da23061c9f5cbd82a2a9901aa51564f8a7c77c900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "241fdf7f6f9b1686690ab62e4dc616e1a40b549b2a7699d282aab81121fcf1e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45f87c63fb74ff4747e04e96bbd31722acaf47232b5b19708e540199d9221ebc"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa5c27bab5c0c6fa0cbc5fa3e63c20d0272639f758966fef7f23026356e85f4c"
    sha256 cellar: :any_skip_relocation, ventura:       "05e5a00cd598c406d95dab448b9d004b1800fc9d7bf979b32f399ee037964ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed65f2f4b0605ccb4f4b1e27cebdeec31fda08805942ca91fe98c635795b3643"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin"steampipe service status 2>&1", 255)
      assert_match "Error: could not create logs directory", output
    else # Linux
      output = shell_output(bin"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin"steampipe --version")
  end
end