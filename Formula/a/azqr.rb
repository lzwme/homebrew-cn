class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  url "https:github.comAzureazqr.git",
      tag:      "v.2.4.3",
      revision: "f3eb47c1e83cf33893d7a11bd6e5f4f563ca7ae9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c42a859b65e941eea0c6502144cefbe511e25d98021b3cb0dfc135a6171a0c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c42a859b65e941eea0c6502144cefbe511e25d98021b3cb0dfc135a6171a0c91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c42a859b65e941eea0c6502144cefbe511e25d98021b3cb0dfc135a6171a0c91"
    sha256 cellar: :any_skip_relocation, sonoma:        "472a5d40c4826e74b503c67b33d524245f0cb3b21870c02dd9a911b9842f1a52"
    sha256 cellar: :any_skip_relocation, ventura:       "472a5d40c4826e74b503c67b33d524245f0cb3b21870c02dd9a911b9842f1a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4cc6cfc9c55a9455cd3d9a8bb0a0449208336efe7bd073e46aae3fcc6b684d7"
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