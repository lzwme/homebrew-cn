class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.28.0.tar.gz"
  sha256 "35c39f46bc498a145e24282479853b78d9c4127fd871fceb3d3c5ea9e76e4c83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "248188e3f8ff4465ea472e37b87dafd02577ded0316ee3b691c5a3907bda7808"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7febd5c9175a83be0e587246b1b047707d5232e5d375924d4979f3d3922f0058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "862e2395e4b25cf807282e99ee24efaa2de8fc15e966a4d80260dc514f347cb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "88ed1012b50bb6dac8cd8cf32bb031d85e0c5c6e2de9f7d5b29838c5a874e232"
    sha256 cellar: :any_skip_relocation, ventura:        "f55deddf8a0a13f1fe3a32da85a7481d859bc861ce028c9a2cca27bc82e482f7"
    sha256 cellar: :any_skip_relocation, monterey:       "aa779669f195f4a04352d558ac9496e08b02cc73a99fb26c55cdb21bf39b1d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "599018bc72847e79df7fdbbb391290d731456d2823d63cadb009aa015501ae21"
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