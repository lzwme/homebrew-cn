class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.11.0.tar.gz"
  sha256 "e317ccf54fbb005a9e1024fc39504bc5201a397031ba7e41d2ea6776675d2a53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccc2cd04dd4d6127bec323bf9815593f61ccb14bd5b7371a9c4f1df1253a6d87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f6bfd7ee3a4e4b40b74e3c370b2420f40b31bcb663b485110ae7e1b97ac3da2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa9efae4c660ec5251cc21989a2d3f625d2ab57d6603acdaf8fa86e647fb6161"
    sha256 cellar: :any_skip_relocation, sonoma:         "db58d9e061fe86c7f8091a633974107e15ee22b0fb5128e5004b0bb6888174bf"
    sha256 cellar: :any_skip_relocation, ventura:        "f0da171e27ee73635297d5fc0905232187c66d10ed57e8f20cbbbd7c258719ad"
    sha256 cellar: :any_skip_relocation, monterey:       "8cff03652610f7ef118126c4905132a62513bd414ebb8ab66d3a02b2cb37c372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f67fbe374d8db90cc52e34c39e98776f3ef6223fc00d32725bfdb59ced75637"
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