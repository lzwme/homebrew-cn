class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.17.0.tar.gz"
  sha256 "c168125f602f85674743ee1e2471361f34ec1a71164e019f7c0190af5b996843"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d350a723345177509869d1da24d506e487c2cc549665fdabf80bb476ff9004e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4f2975e10d8a9133aeff3a3db2df4e62b86ec7972a51b1c890c0ac70358452d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24a87b5e700a92195da10442dc7b428459f04129efc037d12a492fc9f0dde8ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bef68ccf6d4eac2a51725fc0bb15a50a4e927d68c813b6ecb49947bb98778fe"
    sha256 cellar: :any_skip_relocation, ventura:        "c40745449c8e42f7e11652a7fe8d510045992aa42d43a66874ee76e2b54a23e0"
    sha256 cellar: :any_skip_relocation, monterey:       "495841a52eb6a9083d390b1ae78ecdd7c928461d0dc28e8d913126fe682540d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519e20269de510350262d3ce382eb45d6fcf311e2147b1c9b05b13bb979b4279"
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