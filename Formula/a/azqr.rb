class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  url "https:github.comAzureazqr.git",
      tag:      "v.2.4.2",
      revision: "8bbfa0227e780390b2f0dc03a2c3b63b4031dafd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "065a35d9231d236b9d22dbe194600a2252455d3de4edab9b63b5add0c9b00428"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065a35d9231d236b9d22dbe194600a2252455d3de4edab9b63b5add0c9b00428"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "065a35d9231d236b9d22dbe194600a2252455d3de4edab9b63b5add0c9b00428"
    sha256 cellar: :any_skip_relocation, sonoma:        "89cacf9891df7df31e17fea9004a25b091cb907d7e105a170c5d8624d219bf2e"
    sha256 cellar: :any_skip_relocation, ventura:       "89cacf9891df7df31e17fea9004a25b091cb907d7e105a170c5d8624d219bf2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e284c213f44ee2d212a043b816c6b64a444b17654555169f0ca4b674f352998a"
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