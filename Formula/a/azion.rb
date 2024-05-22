class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.27.0.tar.gz"
  sha256 "3b90853e9f30ba91bb4a4362803f06a4cb93fcd5bd0e642b02adacee10171843"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4defaabab839dec6730c8b1ab5bdd7b3be0960cd6c364e1b8b5e1a64dd2463e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aff7d39c46ba11ea5df58f5582526bd1c0fccb092804ecfb78b4a48756aac72c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2cbd4421d9cd15e0e9ac9546916b6a64133958e6df8e2214713f018b2a15bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "e083dab52a371b5dc9fa25ef5d9d56b154df18c38b642989b570a6770418aceb"
    sha256 cellar: :any_skip_relocation, ventura:        "85814c98add1c51e32599608e5158d3fc837c73dc2567e2bf713e2072ecabdbe"
    sha256 cellar: :any_skip_relocation, monterey:       "ac2fa2e11f2efc9291000627a738637e8a48791abcd1ed59b6809509ce176988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b240538d3ecb62902396db20b27464eaea496f82b3f946e370661a5451fbe0f8"
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