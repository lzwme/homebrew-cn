class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  url "https:github.comAzureazqr.git",
      tag:      "v.2.2.1",
      revision: "8934c46e166438dba8f4a1ebe336bc20b19be68a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfa1ba913e5f78c7e49a99200caaffcba3032648d8fc379a5c4eee579f7f43b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfa1ba913e5f78c7e49a99200caaffcba3032648d8fc379a5c4eee579f7f43b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfa1ba913e5f78c7e49a99200caaffcba3032648d8fc379a5c4eee579f7f43b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "54b60f84f481a5ef90d8340147f605a973d6299e22354619766ed914d902ebbe"
    sha256 cellar: :any_skip_relocation, ventura:       "54b60f84f481a5ef90d8340147f605a973d6299e22354619766ed914d902ebbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de46b873ec2e4ce55dc1431558b49c08023e13225c065813a2a6155f470a69e2"
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