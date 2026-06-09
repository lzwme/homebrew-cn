class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.22.1.tar.gz"
  sha256 "a96d6f3387438fcc7ce9ad634aacbe0d40b0247a117f53c163e1371521d10a7f"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bbb6120c2b153896ad0616b5f6f7ab05eb5885156ba4105161bdb224cd04bd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bbb6120c2b153896ad0616b5f6f7ab05eb5885156ba4105161bdb224cd04bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bbb6120c2b153896ad0616b5f6f7ab05eb5885156ba4105161bdb224cd04bd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "37f73bd3e1e6a547b2a9a7cff295941ce7433c02a1085752094f04204548efef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08c5ddd9d54139f6dcf2afa18d41be8b591c652208bc9ebf576217c9f794230d"
    sha256 cellar: :any,                 x86_64_linux:  "1b31ed6e5a36e36ce020e0d688f145b58f8140a13e9084463d65f8221aadf1a8"
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

    generate_completions_from_executable(bin/"azion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end