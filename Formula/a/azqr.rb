class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  url "https:github.comAzureazqr.git",
      tag:      "v.2.4.0",
      revision: "4fd83411f9b285a8f5b5038c0396726eb65cef82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7703b945a6707eb17dbd587140397ad4b41ac1e8cdd54d7fff33690bdb68afd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7703b945a6707eb17dbd587140397ad4b41ac1e8cdd54d7fff33690bdb68afd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7703b945a6707eb17dbd587140397ad4b41ac1e8cdd54d7fff33690bdb68afd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e83e0063a69f05d52c16819278f108d7f59c53635bdb1d8fdbb7ba8c9aec21c3"
    sha256 cellar: :any_skip_relocation, ventura:       "e83e0063a69f05d52c16819278f108d7f59c53635bdb1d8fdbb7ba8c9aec21c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b873052cdd5adc7c2826ceb9d565eddb395a9541a4d77858ba1b7dd6e5a061bf"
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