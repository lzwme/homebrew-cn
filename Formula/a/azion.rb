class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.3.0.tar.gz"
  sha256 "46c51794deb552208073e81b69f63764590513f9a0b3096cacd1283a83ede328"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a09d41eae92a8bc04a968b6e68303a24f394f022fe752bc9ff2d12ad5abd216b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a09d41eae92a8bc04a968b6e68303a24f394f022fe752bc9ff2d12ad5abd216b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a09d41eae92a8bc04a968b6e68303a24f394f022fe752bc9ff2d12ad5abd216b"
    sha256 cellar: :any_skip_relocation, sonoma:        "401793446a7d98f93038e0dcb6ca102ad3bf762f9b7e0f2f059ee8a22af3f136"
    sha256 cellar: :any_skip_relocation, ventura:       "401793446a7d98f93038e0dcb6ca102ad3bf762f9b7e0f2f059ee8a22af3f136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af5eb76d28ec5d14153236c7e52ade6c639b44516d0fc5dbaf4d67d36e125786"
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