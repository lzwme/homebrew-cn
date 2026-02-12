class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.16.0.tar.gz"
  sha256 "581dd9a5e77f4587da5dcfcac49f5da0c5bec394d3eaa377ff7a5f2aed4d6663"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1f15e30c52d8246a527d691bc51187b880e164d4e8f458559201bc9a51d82b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1f15e30c52d8246a527d691bc51187b880e164d4e8f458559201bc9a51d82b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1f15e30c52d8246a527d691bc51187b880e164d4e8f458559201bc9a51d82b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "adbb316d5ed3e00037fc2600def871792348809f6719f4b8baff58ce3aed29fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f54575e082a02435d51d8c89f205c26086c77ab340b5774a32184b5dba2932b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae3779bf1a94c6d51cd96c66284fdc182277d540fe64509dd0a6d8368b6c0253"
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