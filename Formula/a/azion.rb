class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.13.0.tar.gz"
  sha256 "1d90e73957abaf84cf9ede427c0297f62e3f9a589add4b4dd9171afa266b5971"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a2c54279fb2016e92aad1317bda0f0236e040a0577eab8df5a41bef4b1b4640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a2c54279fb2016e92aad1317bda0f0236e040a0577eab8df5a41bef4b1b4640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a2c54279fb2016e92aad1317bda0f0236e040a0577eab8df5a41bef4b1b4640"
    sha256 cellar: :any_skip_relocation, sonoma:        "5827f2173b6a3a2f0cb952080b327ce87bbaf86170110eea1374f7675bc63fc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "847b900d2415884e77cc4113802ba8720e6a2f5b06cac078920d257043442e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22fc299a1acb6c52227c26afc4346ef82a9a7ed950ffb8075b96cdb105f27b30"
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