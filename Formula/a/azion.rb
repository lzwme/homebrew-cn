class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://ghproxy.com/https://github.com/aziontech/azion/archive/refs/tags/1.5.1.tar.gz"
  sha256 "26c362b63075afac06a1c0a70f8299c0a53ae9ad38f3eff7f6b1af04e7b83e18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f32f992da53e8456a111e3a17a33843847a1b94abefa9266c9cd149245a8107"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b76e3ce0856bff9805fc42c2f35d5e388a74d8390dac6f4daccb275603746c82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af8aaa7851146fdde985da23c6e614aca190f2be2df3e0e66655e6b3f8031479"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dba4db76aa09ca708271f812b212e55afd4433e1b498ae8a5b6b3915adbbb0a"
    sha256 cellar: :any_skip_relocation, ventura:        "6fa4a0d92ccd654304be7256a80cf29ae61939e4453eab65f4e2890718a9263a"
    sha256 cellar: :any_skip_relocation, monterey:       "e0415d53e27293c30ad0d04262fd7e852e557c2b9e6a23d5558a523fd17ae158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc24b523ecc0f084f7a2a65da98091b1cf6b52f4c9b1cbdbecb40a258a04596"
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