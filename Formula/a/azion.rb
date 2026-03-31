class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghfast.top/https://github.com/aziontech/azion/archive/refs/tags/4.19.1.tar.gz"
  sha256 "d692a0a99f5c3cadaf885918fc247227ea0adc85ea48dd99b78b6dc1a857a14f"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eed70164976a5a8fcfede86d2ad12fdcd5d3120165eeb22017f693970dc9556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eed70164976a5a8fcfede86d2ad12fdcd5d3120165eeb22017f693970dc9556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eed70164976a5a8fcfede86d2ad12fdcd5d3120165eeb22017f693970dc9556"
    sha256 cellar: :any_skip_relocation, sonoma:        "86dfcb4f3ae4943a5366c50f8982f69c6d2d416950d00571f298a5e04090dd4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84c87cc50af7d6a8a8a61d5efcda2b50a0f0a6bfa636ce94e4c76a08e634dae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45e30918e6a99793f5097a9fc4a0c30c4130566748d819fe721e2ac63cefe591"
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