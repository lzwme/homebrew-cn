class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.33.0.tar.gz"
  sha256 "f0ab7e2b393e62ab1d4ac3312ec7c306c95bffcf705963a64753e9f99b04feee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8b3141614c7fed55aa4310264f37af6715a4c87672454118e430b7b959830cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20e342116c824a0cb0a8f8f2184efe6705a97fdcf72ac3a61bd26d5ff0cfd5e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0be5c3f0bc84f3701c3c099001e92df0132108d1d4e9c3ee8fc5fb246d1f3ae3"
    sha256 cellar: :any_skip_relocation, sonoma:         "77ca75460a082912db21cd8d9ded8217d9454954cf309cacbc37262fde2b158a"
    sha256 cellar: :any_skip_relocation, ventura:        "ad8e9582ea6c9104f4e6a3c8482163b280bbcbdf1632cc1a46988b3c54ccb79a"
    sha256 cellar: :any_skip_relocation, monterey:       "1bf34f1ce53bc6c746190275c93a27545176fdfb351b9e4513f1e98bad488d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28b7fd0706270420b6d13ad00f2d902f59392d1b33aeef2fb3481026be49fae4"
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