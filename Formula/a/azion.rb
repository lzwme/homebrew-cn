class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.20.0.tar.gz"
  sha256 "b95db9ef531d4def43b1f3cf862fb0fd69d2fe881ed78366f4a3a7fbd1944af3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b6e01e223ba8d5639c1929d6a0fe733da1c2d7692e829852de6c3e416681b2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ca17dbf677f8f5d17dfe5f637c3dec90da164dd0130501b0b6fd6094a6a58f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b7ed6e9ce375226c0893b1c3856a15cc4efda49c3fde5e41289298e00f15fb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cd42ecd342755b2b9e2e2f51b995d59ae6c4e8c32e398d0025af51be292ee95"
    sha256 cellar: :any_skip_relocation, ventura:        "1e7d3a12fe4ea85291b86be6f104672b5b612a5ad2569fc10c63d274b087e5fb"
    sha256 cellar: :any_skip_relocation, monterey:       "ab42ba8042ed7a5aca6622c2321d3ce79412d42acb91d8a816dec3e913ada01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "606e1471e4fb848e917301bf38f98c0a35f378ffe2a4aaff88eaa1f003b867e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaziontechazion-clipkgcmdversion.BinVersion=#{version}
      -X github.comaziontechazion-clipkgconstants.StorageApiURL=https:api.azion.com
      -X github.comaziontechazion-clipkgconstants.AuthURL=https:sso.azion.comapi
      -X github.comaziontechazion-clipkgconstants.ApiURL=https:api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdazion"

    generate_completions_from_executable(bin"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}azion dev --yes 2>&1", 1)
  end
end