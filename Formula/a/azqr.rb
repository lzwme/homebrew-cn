class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  # pull from git tag to get submodules
  url "https:github.comAzureazqr.git",
      tag:      "v.2.5.0",
      revision: "002744ef038e8198885c96523890ac4c763800cb"
  license "MIT"
  head "https:github.comAzureazqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f157715143489072bbe732512c9242f570f92d7ab47125298e322e8f9508e061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f157715143489072bbe732512c9242f570f92d7ab47125298e322e8f9508e061"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f157715143489072bbe732512c9242f570f92d7ab47125298e322e8f9508e061"
    sha256 cellar: :any_skip_relocation, sonoma:        "f256d86d6e0528e696ba1afc3d67e93ddd938387e3a30d36f3787ab475fbc2e2"
    sha256 cellar: :any_skip_relocation, ventura:       "f256d86d6e0528e696ba1afc3d67e93ddd938387e3a30d36f3787ab475fbc2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "043dd14a2ccabab7aa486c08bb972fedae5d68122b9c75cd4366d513605cf2e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comAzureazqrcmdazqrcommands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdazqr"

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