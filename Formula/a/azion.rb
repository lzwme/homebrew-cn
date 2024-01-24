class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.10.4.tar.gz"
  sha256 "f074b082947d11dd2b91b9671e61092982cb22da405216e52c2528a54832dcfe"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3b3d6eda2a5822cb78ca5fffff5c37b8fe0d2c28c6356e2ed88c9f087500804"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4487ac378015057c224470baf75ca08fc1f75e18ac046fc0e1644e327a1a59ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "587d1e6b1dc43179ccbce436dc0b352e71c1eff9e9a247eb134f0abb3d7be925"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5621cf2d316c5d4de415b3a35866dd731721148b090488224f5cdb72c86055e"
    sha256 cellar: :any_skip_relocation, ventura:        "13678b99c6008cb5ba517b14f9ae7e7c59acc5a03f2fb35a9e907dc22c0a327a"
    sha256 cellar: :any_skip_relocation, monterey:       "e3c979b4eb004d9ced6b7730bfaba705e9b09df68cdd49435920995b9f64b76c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aee2860493dc890bcac98e55abc7866ff7ac2b4c7e728020ce896e69aae4d347"
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
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdazion"

    generate_completions_from_executable(bin"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}azion dev 2>&1", 1)
  end
end