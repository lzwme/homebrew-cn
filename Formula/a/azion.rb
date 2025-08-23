class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.1.1.tar.gz"
  sha256 "416428fdb1c0aa027c9200b9e06bb7ebd608641d8af6446604e5ea4e7bee5030"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10789bbaf172c5dd3df7bc124f30c3e1724f9973928f9d1ee28cfd0459754566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10789bbaf172c5dd3df7bc124f30c3e1724f9973928f9d1ee28cfd0459754566"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10789bbaf172c5dd3df7bc124f30c3e1724f9973928f9d1ee28cfd0459754566"
    sha256 cellar: :any_skip_relocation, sonoma:        "cceca0a8dcdcce936914b6bb69a7383e655f68cbe3bfd6e6bdae71d56ffa05e3"
    sha256 cellar: :any_skip_relocation, ventura:       "cceca0a8dcdcce936914b6bb69a7383e655f68cbe3bfd6e6bdae71d56ffa05e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15fe655dc8445dc36bc7a4eda9cba52a68264e7f9f3d6f81f3160d7d5352839d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV4URL=https://api.azion.com/v4
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end