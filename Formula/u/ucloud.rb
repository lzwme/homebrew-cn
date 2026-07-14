class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://ghfast.top/https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "1e2c0d418ef1f916f1c7659fff1de298ebfdd28f6f343cd40d31a37c57366b2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5750e4cabec3c17a86539bee4365e6ea10010768a08bfa8149be527bff2af886"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5750e4cabec3c17a86539bee4365e6ea10010768a08bfa8149be527bff2af886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5750e4cabec3c17a86539bee4365e6ea10010768a08bfa8149be527bff2af886"
    sha256 cellar: :any_skip_relocation, sonoma:        "aff773ffc00b2ae256618715d1aff541d5cbc2e9b7c938a795fe52c068a3fa74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e3292140ff7c8b79c43e22cfc23ea73910b7f834aedbf3b2484b7d4df293d6e"
    sha256 cellar: :any,                 x86_64_linux:  "e6cc022f382d626f4d17e668cde3937d72424e8cf86d47386787c0918350a54a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ucloud/ucloud-cli/cmd/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end