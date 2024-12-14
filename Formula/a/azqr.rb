class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  url "https:github.comAzureazqr.git",
      tag:      "v.2.0.4",
      revision: "4891102e05bf35064017eacdbc5415b92a39795e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fe387fb54b38d927467721572d04fa2d5b0eaaa5473bbc43da0de90d9e66a4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fe387fb54b38d927467721572d04fa2d5b0eaaa5473bbc43da0de90d9e66a4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fe387fb54b38d927467721572d04fa2d5b0eaaa5473bbc43da0de90d9e66a4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7db8e17e2c70e6130efaad71eb47ee692287de96e12bca0319f70b6ee2e2e993"
    sha256 cellar: :any_skip_relocation, ventura:       "7db8e17e2c70e6130efaad71eb47ee692287de96e12bca0319f70b6ee2e2e993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15c3fd690c8100b228c68d531cefd7ef3ca1266b34d538fa19aa52267bdb709b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comAzureazqrcmdazqr.version=#{version}"), ".cmd"

    generate_completions_from_executable(bin"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azqr -v")
    output = shell_output("#{bin}azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end