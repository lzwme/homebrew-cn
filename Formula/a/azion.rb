class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.34.2.tar.gz"
  sha256 "606445e531a75a91aa04d65e040af975be8fc4959bdf11f5d3990dbd815d2569"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dae68d7496d6a9c4148f95708ba9e34870f9448b0843ebbf76148a34e81df374"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a97066e65b21312b5d29e8f53636248decd5aba12e4789e573602c730dc3e85d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7c34eb480838772e4281cc80c4d6aac20e83f7f48acdc1e4b03aa9847ed2ed3"
    sha256 cellar: :any_skip_relocation, sonoma:         "dad0a10243d268494113d702126c6dc165be802c4db900429f58ad554f74ff79"
    sha256 cellar: :any_skip_relocation, ventura:        "eff0994c32b29fd8cd1363ac4198133e55f31f9b182bda5e88808f2a22778c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "2d5f34a5d53f13e60aa4dd4de422deca3bf4895c9f403196228a9b52de6aec5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc4d82e095122c198ee2fcba1e015353ac4c053d927d3457d190938c215a6a3"
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