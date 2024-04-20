class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.19.0.tar.gz"
  sha256 "16e8bfd5e3fe7db3b0cdc88c1338d1c613c02a4b42739ee8355998856e5cb9ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ecebda45e0aec78cd40a45de1de5a66c7bd1f8e527564e82e803fa2a899a966"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48a3a702bb485cd5fe88c6e506bc519728c63628fe91abcadad626547aa0909c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d79d5dbaccd6dd819cbed3bf16678dbe09c71b168575d540daaa0748625ca7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a00246c134495ebc4117c6c75df54c919d10f422bfeb62b52448990b39a3e10e"
    sha256 cellar: :any_skip_relocation, ventura:        "1233875aeb20f82508d60e041492ee9943237950c5ffe05c9ab049b6e05e88d7"
    sha256 cellar: :any_skip_relocation, monterey:       "66a6d7ffaeb4e75f5bdd764bcbff454b09447caa02dc141766bb1709a0cdb898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47dd196ce6a6dad197666eed27f40307ca5ead2b554c1abed394a4a755e3dd6b"
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