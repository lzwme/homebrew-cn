class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  # pull from git tag to get submodules
  url "https:github.comAzureazqr.git",
      tag:      "v.2.6.1",
      revision: "baff1e87f39f778b175db53e04f0729a0f12f111"
  license "MIT"
  head "https:github.comAzureazqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90f1615b1df5560d4868913bf0448e495f86446ea9214dad12c5eaee6b26383e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f1615b1df5560d4868913bf0448e495f86446ea9214dad12c5eaee6b26383e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90f1615b1df5560d4868913bf0448e495f86446ea9214dad12c5eaee6b26383e"
    sha256 cellar: :any_skip_relocation, sonoma:        "33f7945d88a3d63d5b95c984920a600a27c93ff6f5a76e67e9a471b5e7d0d571"
    sha256 cellar: :any_skip_relocation, ventura:       "33f7945d88a3d63d5b95c984920a600a27c93ff6f5a76e67e9a471b5e7d0d571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc0dafb9589641ce3fffd8ecffedce4a8a75902ab3d505776e50762b6f7ebbe5"
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