class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://ghfast.top/https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "06d1c76ae0523fbd94ad5b87ea1f20fbc16379e1716aa8dea837eaf571e72cf5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b513ea044a009f25bed91429bc73bfb657e0f4d818259534f2ae2b47312b385"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b513ea044a009f25bed91429bc73bfb657e0f4d818259534f2ae2b47312b385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b513ea044a009f25bed91429bc73bfb657e0f4d818259534f2ae2b47312b385"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5fb76107e1e412fd083095b5b5163a937a78073c5035e2b1fa593e81d3151bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74e3e92c563dfe4915302990e95905df8e47f9831600216ffc12d052a8e053a0"
    sha256 cellar: :any,                 x86_64_linux:  "e6f3137091843d9b2f0c2031e1b0ca30a97fd7ca1cd9af5fe5223d426032c1c2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ucloud/ucloud-cli/base.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end