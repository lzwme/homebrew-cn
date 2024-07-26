class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.33.1.tar.gz"
  sha256 "adc37bab2e763b9b13537468b665099939ff7b3aca67fdbaea86d941ff751fe4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "348be7ad43e115cb810134d937d9d10c0f0b141c737e5985fa770dd9cfd5f37b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12e926dd905feab52d7c8b54af9709c6240c2510aa56aa53d8658d0e97dcc188"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f83aad2369e3f4047cdd128936fa0131b798255fcd5e97176cfe2cdca2084a1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ada2906dc10d57c6c5a6f16cfe6da68b1f0bbbb1ff3f2dcbfe21b7eeb06c8b4"
    sha256 cellar: :any_skip_relocation, ventura:        "f1c86652f60bfed1a6d0cc1e8eeda79c96ae5df6f33e62d45074d146c131c0b7"
    sha256 cellar: :any_skip_relocation, monterey:       "f5c473d4da9caea0fca5c473f005d884596f38aa36a68f66b52091c15649802c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c47158f01ed72b0674cb2c7b9fd3258641e1f5b96aaf49ac51569c6cc321cf"
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
    assert_match "Failed to build your resource", shell_output("#{bin}azion build --yes 2>&1", 1)
  end
end