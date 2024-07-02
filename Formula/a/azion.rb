class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.30.0.tar.gz"
  sha256 "050c751b8f2ede02280c429d2ca9039ddfff684617deb2d17cfaa3f3aae89ea9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d262d05a1abe322461d187d4df4e75800e71e8b657afb1fef8fb0066e80869a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07ae9eac2e83424689d0b0cbbf42b45ac2e263f4b69d5d6aaf4766e5664360b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bb1274f828fa3d761aa58c53ab5a90cf6a365fa8122e339eb7511df538e2c02"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a510738055e889168b8824c410b490e11be49370cd605660e71e6a4f2adf007"
    sha256 cellar: :any_skip_relocation, ventura:        "e97b6178f181b092db960695579fe831d56c83508069511c1d8cb44d5eb7a754"
    sha256 cellar: :any_skip_relocation, monterey:       "22291feeb54476bee4cd9b38825197942e2993b68880eb466c8d6344f1710b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b548b59740350b190d382f00b905db5b8ec423b1f6951e189cb4dd3cc103b87f"
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