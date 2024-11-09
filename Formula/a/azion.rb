class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags2.3.0.tar.gz"
  sha256 "c7f94824fc4c47451627ced1cdadfd7fcfe47f4edaec084747bf24dccc0e05d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2b1f358d18688d05b8da30f1c8202a51a347a373abc1c1b060ca4e45ff8da92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2b1f358d18688d05b8da30f1c8202a51a347a373abc1c1b060ca4e45ff8da92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2b1f358d18688d05b8da30f1c8202a51a347a373abc1c1b060ca4e45ff8da92"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4f1680d1ca2b46767d26aaa7edaf38342fe0a6c725e6aff75e2185d749cc5f7"
    sha256 cellar: :any_skip_relocation, ventura:       "e4f1680d1ca2b46767d26aaa7edaf38342fe0a6c725e6aff75e2185d749cc5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b7488d89549edca1ca35eed8954c3ce23f6bc791bc087bd45d1a74c03b2e9f4"
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