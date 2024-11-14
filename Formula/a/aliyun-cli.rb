class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https:github.comaliyunaliyun-cli"
  url "https:github.comaliyunaliyun-cli.git",
      tag:      "v3.0.232",
      revision: "300d632d40627867be9ed549a8d25422ae76681f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca3cc69bde270e1d139faee156a486a19ae12c4fea6cdc5264a95da9abe9094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ca3cc69bde270e1d139faee156a486a19ae12c4fea6cdc5264a95da9abe9094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ca3cc69bde270e1d139faee156a486a19ae12c4fea6cdc5264a95da9abe9094"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a62041a07999fb724bd4ac35eb65623cf89042b1f55480267b9a558d0f5864e"
    sha256 cellar: :any_skip_relocation, ventura:       "3a62041a07999fb724bd4ac35eb65623cf89042b1f55480267b9a558d0f5864e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a8387a52a0e77a629c6077bb68a9eab7f26cde3575d0d4f4e0c705cb7adb6a9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comaliyunaliyun-clicli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin"aliyun", ldflags:), "mainmain.go"
  end

  test do
    version_out = shell_output("#{bin}aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end