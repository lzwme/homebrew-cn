class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.10.3.tar.gz"
  sha256 "c91c56a2ec416ddc31faaf8c2b8e041eca5eabe0d2acdd5904fd9dd6ba3ef3bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e62fdb04d620d08c1069a2600091200dca7dbf6b9791e23f4facc4497a0d87b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46ee4c4e0820d910c9ccb373eac82e628081f119a4910c4939851e239d876370"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0cc6e80586b6c489e05d9fd69aa2807756ebb1b8566cfd563bad069a555839a"
    sha256 cellar: :any_skip_relocation, sonoma:         "773f782937b6d0811304c9f9a315bb6934e7cf51cb73273c89e1173ec8f18235"
    sha256 cellar: :any_skip_relocation, ventura:        "d3cb0e26b878b7d7a974b2ea7ed11813ee5445e6c0c9881dcecf702911d543cf"
    sha256 cellar: :any_skip_relocation, monterey:       "a229b722e04efa4d763276b91a510a388c59dd6099e1454a79a3f6002aa5c7de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d58a08ff4327f0057849a669f677c3d38d5e2fa622621e2d7f907fb0f376740"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaziontechazion-clipkgcmdversion.BinVersion=#{version}
      -X github.comaziontechazion-clipkgconstants.StorageApiURL=https:storage-api.azion.com
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