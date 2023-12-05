class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghproxy.com/https://github.com/aziontech/azion/archive/refs/tags/1.10.0.tar.gz"
  sha256 "3ab6fb8767933f11a7002b5215e732552b18c16535354cefee97f7867f96856f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4c4d3b5d31bd2628fc5c474ef371152239ef220e6ead2eba4782cb0631727d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77f80327f0ae8a508ffe3cee4d852aa621c5aa2ed25fa46c6e367debf49383d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b898c21e971bbbb20f856022a89269e83212103b4e62e51000f2712bc781cb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a837e6d37d2509b087a3784517bbab81a6ee93bb302331143cb73547c778328"
    sha256 cellar: :any_skip_relocation, ventura:        "90034a919a8d4d2445e6af206eab1664eb20d2aaf32236888f5c2a54e18f611b"
    sha256 cellar: :any_skip_relocation, monterey:       "14b2349e074b1177479deccdfd30e3fbe76cc788f620450ea1cb52150d20b2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37937b8c4adbd3e65f7ddb65649d270683b8d91c470a4fbb674021005e23b652"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev 2>&1", 1)
  end
end