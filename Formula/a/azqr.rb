class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  # pull from git tag to get submodules
  url "https:github.comAzureazqr.git",
      tag:      "v.2.6.0",
      revision: "43e0ff48c8200c93df3f886f9ca58449c4d49c96"
  license "MIT"
  head "https:github.comAzureazqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a69168f96682515e4d85bf989467de86671c4c453e5e9d94ee3cbafcb058293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a69168f96682515e4d85bf989467de86671c4c453e5e9d94ee3cbafcb058293"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a69168f96682515e4d85bf989467de86671c4c453e5e9d94ee3cbafcb058293"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f8689a30739957648b249c54e43a513a6b53e450bc712e4f9be8b432876ac3a"
    sha256 cellar: :any_skip_relocation, ventura:       "6f8689a30739957648b249c54e43a513a6b53e450bc712e4f9be8b432876ac3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fce8c9d8fe11a602e60c6c06feef2872b3ecb50927917591dd9518a01deb16e4"
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