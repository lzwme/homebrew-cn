class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.11.1.tar.gz"
  sha256 "0873ef8f8992fdc3ab68245aacc1e10aca5308315844c871bf6407a75fa5ccd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2295f1db31903a0d99b9019c74c8b96c2567c610144d010a88cc7495cef73f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a69cb6ed4d031db6bcf2366948ae3c508d66b3caf8c11242ae2f191d5c4d30eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4603a2f569028f513fe236259af2fbfcee370ddec30b89b97c855b885b97914b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c8aeef7600e195c9b01f5560efbab90462b7439a9fbaeed9957358ab9d3744b"
    sha256 cellar: :any_skip_relocation, ventura:        "950e8ed75f2150f2345db0b850ff4871ebf72b7c7c792e2089716cafcff9a0d1"
    sha256 cellar: :any_skip_relocation, monterey:       "66154b31e453e7ecc6a0d2f7661d3ab2d6281d2e68aef29ad8bbb9b23c621c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66cf2592d9db56296d52353e8102f18bb9eaf985062e1f83281f8ac775aa56d7"
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