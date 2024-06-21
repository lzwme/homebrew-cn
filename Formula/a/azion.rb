class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.29.0.tar.gz"
  sha256 "cad7a185dfe7792e793ad352dc9d151e0edc5fb9042bee44773d3e62d8d16222"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db64ebe22de71f8df4279f158f1fe5f6e9eebd7463b600a82bd172ce122b9e35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78e5a9bbdacff1e570358e2612ee0369c565361510bea36ebb14de94c45b3fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e4894886b7216345d8c8c9fec8b5ebdce907612dd7edbc9758f55da79b9060"
    sha256 cellar: :any_skip_relocation, sonoma:         "6360e005b35a2a0295439e009ea43bc1bfa4f7d2df78191c54f2a38e527fc3f9"
    sha256 cellar: :any_skip_relocation, ventura:        "94745e730ebee5e1a5d6ac88f8bbbd8ef35a53bbf4714388a164a1a01bd7fc0a"
    sha256 cellar: :any_skip_relocation, monterey:       "59a6a19af8f73e8e6ffb1f99494830be519552c4686eea6a9f8b54e2f9ee3cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e4b322428555bcc8dbef4b848575ba91418c0ab2b812823930274ff09b71e2"
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