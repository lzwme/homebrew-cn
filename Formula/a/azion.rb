class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.19.1.tar.gz"
  sha256 "0a6c84ba421b16ce4c98521d17b6b63689d3d16cd2d6e379574a10cf01e0f9dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbd8e1a42324d7c943e9b2d8c2d20899da574917bbbab5f2b5919808698d5205"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2b74cb283218887d69725f017de7472c849061f1e5db10abcb992138ff39e21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204836fdc659eea7a3a54e18d3a70600ae9a3bc9d4d3933682d696880acb05b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb78a4c9c6d22dc071ccd1cc3fb696b23f62aa18fe487734161068419bc420f7"
    sha256 cellar: :any_skip_relocation, ventura:        "cb167a37945190a5e7fe1f23668232887fa0390759fa82f33fab127ac727ec29"
    sha256 cellar: :any_skip_relocation, monterey:       "7bae52f7151032de518f1f1a1edf2ed1863e293ef37a00a471e3759511d231ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "364406eb185a071c9f5f7a0ad6c9bb64a64f9a3acf66f01109c5d7c6b0920480"
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