class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.110.tar.gz"
  sha256 "09d9718cbec1ce884c575a91d850f863d511f6cc9393f075c5ca76e97f3b88cc"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60009fc0198819c2ad69ad65ec1ea7f5d54317771e489af63b29e8b00d44cf4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60009fc0198819c2ad69ad65ec1ea7f5d54317771e489af63b29e8b00d44cf4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60009fc0198819c2ad69ad65ec1ea7f5d54317771e489af63b29e8b00d44cf4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa5e5bf7d22504296b400877e38635ab72ac2bcc06b24b59a886a1cc440290a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7fb7ef408b8c73399ff9c09631ce0c1d7dea3ea1ffa47a066699c9c9846ceec"
    sha256 cellar: :any,                 x86_64_linux:  "6f8b0582fd10b6e1e6c0c1af638f61d1c469f231ddea135c745fc5440d6789d8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end