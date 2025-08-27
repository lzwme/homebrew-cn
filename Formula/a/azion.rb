class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.1.2.tar.gz"
  sha256 "8261539686e99832bdf2ea17ab36afeca8f5d4a013bb5bc4337c924baedf5a38"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2060403af54aa22ccaf4e79597a4bcee9101ab89b46e7aefb2f158ec265839d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2060403af54aa22ccaf4e79597a4bcee9101ab89b46e7aefb2f158ec265839d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2060403af54aa22ccaf4e79597a4bcee9101ab89b46e7aefb2f158ec265839d"
    sha256 cellar: :any_skip_relocation, sonoma:        "39e1c910f1561726c509a8ba1b8b992769bae61d253ff66d462ac4b2d3aeb233"
    sha256 cellar: :any_skip_relocation, ventura:       "39e1c910f1561726c509a8ba1b8b992769bae61d253ff66d462ac4b2d3aeb233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f503fbbe5fc139f4f5933452fa7cacce9a681f32bb8e39336cc2c80cd3c5fdd4"
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