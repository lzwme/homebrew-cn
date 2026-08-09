class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.121.tar.gz"
  sha256 "538c2ed8047910622c35173d36f5646b61d7733b696f705d5c2b727bbf714105"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3a6b82d981766bf14d4af6b951e1136cc1c3bbc936503e759102c147644d981"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a6b82d981766bf14d4af6b951e1136cc1c3bbc936503e759102c147644d981"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a6b82d981766bf14d4af6b951e1136cc1c3bbc936503e759102c147644d981"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf47f7c87b0bc47a978f8a933c403ef8965a90a36e5ef2041e4c292b78a7993b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6032a62276be207dd6de0405a501792c0716a0a89649a9cf2bdfe678e5e96f1"
    sha256 cellar: :any,                 x86_64_linux:  "ba5ac76dfce9b1f50f3ed960c0f95961779e35e4727ea9578d605b70c68b28fa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
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