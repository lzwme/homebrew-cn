class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  url "https:github.comAzureazqr.git",
      tag:      "v.2.3.0",
      revision: "2e9c6820080db867a4accec8a799b6075c0914c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c2fcb50b3092b7c31c1d472918d796161b2e4f0eb07042d93b44bc12652c971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c2fcb50b3092b7c31c1d472918d796161b2e4f0eb07042d93b44bc12652c971"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c2fcb50b3092b7c31c1d472918d796161b2e4f0eb07042d93b44bc12652c971"
    sha256 cellar: :any_skip_relocation, sonoma:        "22314116c9a63d630d9218987e46230bbefab6b4fddff26220bebcf12e59e0e3"
    sha256 cellar: :any_skip_relocation, ventura:       "22314116c9a63d630d9218987e46230bbefab6b4fddff26220bebcf12e59e0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad747cf0300ebaba4aea4bd6b5700bdc6aa994578a5effef2e75a67fa612d724"
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