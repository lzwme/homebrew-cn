class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  url "https:github.comAzureazqr.git",
      tag:      "v.2.4.4",
      revision: "7db9e2901d9dfa071cb981c843e88dde9451aaab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c0d8009a733259f27ed2d17769b5b10e051157963610b826f3b97ebd69acc03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c0d8009a733259f27ed2d17769b5b10e051157963610b826f3b97ebd69acc03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c0d8009a733259f27ed2d17769b5b10e051157963610b826f3b97ebd69acc03"
    sha256 cellar: :any_skip_relocation, sonoma:        "521330ede8cfed6d74b925821b35c319ebcd24cb8902f24ea9256cffe8a2395b"
    sha256 cellar: :any_skip_relocation, ventura:       "521330ede8cfed6d74b925821b35c319ebcd24cb8902f24ea9256cffe8a2395b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe1501e43206c07f9929b3c56a21ee4e23d235a72f0c754983b9da82d7c061f0"
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