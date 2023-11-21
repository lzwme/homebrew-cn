class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghproxy.com/https://github.com/aziontech/azion/archive/refs/tags/1.9.0.tar.gz"
  sha256 "bd103a9f411e74c1fbc938d8efe81df3ca4f71a8a1d6afd2613484275b452345"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "855ff9b248d6130001897e3d4dd96a0eb7f2efeaf6e0792652195392a2f7d870"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2777ed4d81fe9404bfccaa4b8352462bbdfe71a19eb429c47ff00c023bbc0722"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf45e26876d2cb5e6e496e2bfab022c274a9d669c1e29afce5a4fc448a1b0369"
    sha256 cellar: :any_skip_relocation, sonoma:         "efe0ba7cdd0edffc263078b6fd4f4c0ece3b9853b4aa34c7181964176998afa8"
    sha256 cellar: :any_skip_relocation, ventura:        "eba360c4f8dbfa9beba314e17734ff061fe7341285f445c9ae7ceff6b6f3a0fb"
    sha256 cellar: :any_skip_relocation, monterey:       "11bc605992f882ca0b29be5c02466e2840f7c4fed0db32750da8ac7b63a13efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d45660fc4c6e3c6fb516ecbf8654ec94f02b8581799eab847cc4ad154c78eaf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api/user/me
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