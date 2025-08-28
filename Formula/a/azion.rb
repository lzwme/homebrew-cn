class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.1.4.tar.gz"
  sha256 "3f35c6ba5d2717a9e92ea861e40b55f93ad739df60c31070a72789890b253119"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f65805727b38e5bd989fa6d522b8fc462737d8a230fa0b1e4e35e12875ff28a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f65805727b38e5bd989fa6d522b8fc462737d8a230fa0b1e4e35e12875ff28a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f65805727b38e5bd989fa6d522b8fc462737d8a230fa0b1e4e35e12875ff28a"
    sha256 cellar: :any_skip_relocation, sonoma:        "287c98170744a52bd49bb8cbafe8dddd3fe5dda535c7712f8d0d23fe3e45e68a"
    sha256 cellar: :any_skip_relocation, ventura:       "287c98170744a52bd49bb8cbafe8dddd3fe5dda535c7712f8d0d23fe3e45e68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52d5f37e25e84f2c4a1440f5628f6f9763c7348c5814e8ed5d965b2d1be9751b"
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