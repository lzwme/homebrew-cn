class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://ghfast.top/https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "2f47fa612d340b9bc19e792e4e58078b42a2f8d2e1c67c1801735a82e9ce5429"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ded8e0eddfeddd4275f6d68a845e403dfe084d0ab2fb6de0ac0e43b5f7a8da4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ded8e0eddfeddd4275f6d68a845e403dfe084d0ab2fb6de0ac0e43b5f7a8da4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ded8e0eddfeddd4275f6d68a845e403dfe084d0ab2fb6de0ac0e43b5f7a8da4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c53b333295c75f60f830a6f05a8b2422f08fdf6cd47fe4bfb27798f8aa8564ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad70cb8cc8ed8fcd01b13e7ab89685f17fd4b1be25c3024fc8419e8069f20e82"
    sha256 cellar: :any,                 x86_64_linux:  "cf42cc2feec289f0948fc2f8f5523f9b4e14d0ca96a5f7cda196d8d29e510beb"
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