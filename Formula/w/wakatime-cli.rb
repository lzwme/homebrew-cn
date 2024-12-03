class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
      tag:      "v1.106.0",
      revision: "c41e9c23d428e27517e528442be78aa02ce64918"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d4df2ceb9b85006444b3bf06c9f8e29d9a8b9c59e149c52ba559d51fca7f155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d4df2ceb9b85006444b3bf06c9f8e29d9a8b9c59e149c52ba559d51fca7f155"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d4df2ceb9b85006444b3bf06c9f8e29d9a8b9c59e149c52ba559d51fca7f155"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a598ee5c290e0867c500ab4f6ec8d86f7aeb5a16b0d6bd05628d0f3f82690b2"
    sha256 cellar: :any_skip_relocation, ventura:       "4a598ee5c290e0867c500ab4f6ec8d86f7aeb5a16b0d6bd05628d0f3f82690b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32d3b6d447911e99e6011bb30b7025e6c44bdaab33859bc18fd30ec74ff3500a"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.comwakatimewakatime-clipkgversion.Arch=#{arch}
      -X github.comwakatimewakatime-clipkgversion.BuildDate=#{time.iso8601}
      -X github.comwakatimewakatime-clipkgversion.Commit=#{Utils.git_head(length: 7)}
      -X github.comwakatimewakatime-clipkgversion.OS=#{OS.kernel_name.downcase}
      -X github.comwakatimewakatime-clipkgversion.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end