class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.24.0.tar.gz"
  sha256 "e25152162139740f7ad4cce82d9666c677b9a0c57c68212ee9a8acf0df277225"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a32cbe23b0ed9b44ac936b1238fefba0105858cc671ba57aeada93f6986a405b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d0a906f5b8a520752ed83ddbd07f965cc8cdfe2a15c87273d3ef60b52eb003d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "502639fd7633e08327726167c6fe8d55fb537899e0b5167157c88912c862701a"
    sha256 cellar: :any_skip_relocation, sonoma:         "53135ec5bf42eb9dcacb7fd86bb34403d5561a94c20babf9d9764d881648eff6"
    sha256 cellar: :any_skip_relocation, ventura:        "94c38a9439c969a3cfcb77fb54e62ba26f655a79a939b3d24a81c1aeacd215a6"
    sha256 cellar: :any_skip_relocation, monterey:       "77e2af05f86132ca6bbe42555cef57f7146106240dd529af3c433ee919a9d89c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3690c3cd4294f6011159b89427b42be59c3de481a3f447f1dc219c51a10283f8"
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