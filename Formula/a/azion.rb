class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.16.1.tar.gz"
  sha256 "ee4f5f12ee56ecb703ce09e6595a5bcac3ee381ba7d82838f7aada3a044c65f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef2b5e05bc06f396fc2f1bd3723da34ae9c59f3253099436cceb5f942f01352e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69c38a4f058c8a80a285f3f8f712e6ce73ee80bac6ce8cff9b2e250ef75cac12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fae1d92c41eaa29ec99643bb7dbfb28806ba199f956893954d0144c92ce72d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a36f7b94365799f19b121582ad33361f7d6c21b145a4e865c0588f1983a1917"
    sha256 cellar: :any_skip_relocation, ventura:        "4145cc0de1e3e5601e78744b3d803b4dde2d905542c97ed3a0ba37f2af817b56"
    sha256 cellar: :any_skip_relocation, monterey:       "0b967141792c6857ad1436bb9766848832ff6b2e36713192db98285f5ddc4f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a26428a5e1b5dab421c42398f67627437c5bf57f8e1684bdb73ddaed5525e595"
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