class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://ghfast.top/https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "098e2d247bd1ec8dadf8957e8f7bc88b6ab6745f3d2500d4ce180d89ccae7f4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abd566ef53290e552b6f377b19a4c91729a192c27613a76cfd31c5816a91a841"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abd566ef53290e552b6f377b19a4c91729a192c27613a76cfd31c5816a91a841"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abd566ef53290e552b6f377b19a4c91729a192c27613a76cfd31c5816a91a841"
    sha256 cellar: :any_skip_relocation, sonoma:        "08edf86999a2ae27f7c1f7c486479bf927668dbfe1e57a2020d1ddb17b46883e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43c36a6bc2667de7f0f18c139889f74777166b48188aee5657393218b935f989"
    sha256 cellar: :any,                 x86_64_linux:  "56adab21c0b0a6c1057172457ec98a87b062983fbeaefb81df1d1db4e621cb5c"
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