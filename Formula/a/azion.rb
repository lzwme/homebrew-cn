class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.11.0.tar.gz"
  sha256 "87178c1bf78bcaf4dcce53cb2ceef702fc88645a73c7605f39e247f632451ae8"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7245d964aebbfda59c696c9b2bf2fcf3d4d35954cde0cadd6434966e8f7e392"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7245d964aebbfda59c696c9b2bf2fcf3d4d35954cde0cadd6434966e8f7e392"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7245d964aebbfda59c696c9b2bf2fcf3d4d35954cde0cadd6434966e8f7e392"
    sha256 cellar: :any_skip_relocation, sonoma:        "422a41ddbcda1be51652fa7fc83685b3ab12a9dc79434c52321743cee5911a33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e81583c90cd814f969b54be9c7d6eb7cf283f787992dc9fe571b918635bdb9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aaeff66c89fd1b4d13f76324162887b97930ee16b28675af8a3bf18ff1d9248"
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