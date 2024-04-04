class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.17.1.tar.gz"
  sha256 "7150f3b8b6b3b5669c95ae53c06ef95a977fc158399660761d7a6e36653cbc19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c00bacbe004d784800db85b10e8a6cb8c1621a3564086259ef8696c586376011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbc6c7a58112777c37532593c4c421a9d285b7fa97274e6a3f13688975c9fbfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78a64d224dcc43aeb9a44544ebfb21ae99adb20f2d8cc55d0710ea339aae44f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7522f848539c09b50ca4664d190bf5653c8762e01ec44e624678b1a5b2b9c34"
    sha256 cellar: :any_skip_relocation, ventura:        "2c1be8eece59d39298b71a1e7aef6d795e774408d9fd7a880dc65c060ecd1b11"
    sha256 cellar: :any_skip_relocation, monterey:       "1a0e1c22b9a6368f75c8d8a9f70c6459079aeecb149d15c7967f9e708a48f232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "013af84f4a5a2d66a53092d58efeee9b0fda6f1dc14bec06595e9aa312f754ed"
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