class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags2.4.0.tar.gz"
  sha256 "7ea1bdda6647132b479da7a416d4fdc2fa795d445cab0cc2b5ccfc7de5a80281"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a80461c1eb074ff053bd2c749307107381fc4e968eab10646bea3924f18058c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a80461c1eb074ff053bd2c749307107381fc4e968eab10646bea3924f18058c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a80461c1eb074ff053bd2c749307107381fc4e968eab10646bea3924f18058c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d25110a491c63198cb8f516b842e4ff10b7e4177c56968fcdf64b43610d0386"
    sha256 cellar: :any_skip_relocation, ventura:       "7d25110a491c63198cb8f516b842e4ff10b7e4177c56968fcdf64b43610d0386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70962780a4afae03912d18b46afb3cf12c0d4af927a8fb6931f53794c2d797db"
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