class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.36.1.tar.gz"
  sha256 "15db2edec05e816136887b35afc593a34f794cff64491fc7c191d06da0d5ca98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f294c40b8d16463ef3832c04cb6163d0625ccbd7c774631fe8bb324bdc7ff222"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f294c40b8d16463ef3832c04cb6163d0625ccbd7c774631fe8bb324bdc7ff222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f294c40b8d16463ef3832c04cb6163d0625ccbd7c774631fe8bb324bdc7ff222"
    sha256 cellar: :any_skip_relocation, sonoma:         "769cafda003dde9122e94f3016355fd75c41fc89bc3a56e23ce925964505ca23"
    sha256 cellar: :any_skip_relocation, ventura:        "769cafda003dde9122e94f3016355fd75c41fc89bc3a56e23ce925964505ca23"
    sha256 cellar: :any_skip_relocation, monterey:       "769cafda003dde9122e94f3016355fd75c41fc89bc3a56e23ce925964505ca23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bf0e9729b8af38d50e74549d817f8851cd00ec26c0cadafb3d4bca187094066"
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