class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags2.2.0.tar.gz"
  sha256 "274683b245e6efa26835ea2f91710abed09bcd9c55715b9e9bc0f0dc4eba202c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b35bb381dfda23c1e8b22f92e3b455707a66ed6e4bd419d6a7aa9764d8481702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b35bb381dfda23c1e8b22f92e3b455707a66ed6e4bd419d6a7aa9764d8481702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b35bb381dfda23c1e8b22f92e3b455707a66ed6e4bd419d6a7aa9764d8481702"
    sha256 cellar: :any_skip_relocation, sonoma:        "63b21bd5ae110518ca4ca7f371eb3daf782832be232fbe2e629f92f39fb318da"
    sha256 cellar: :any_skip_relocation, ventura:       "63b21bd5ae110518ca4ca7f371eb3daf782832be232fbe2e629f92f39fb318da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf851d229bcdb620f2624fe941aac3df4dd8139171c2ad981772eb102df7b61"
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