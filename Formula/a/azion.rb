class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.39.0.tar.gz"
  sha256 "d72836e1214f77abfd4b844e7e1b40048a76790776b31c068b97f432b871b043"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97274811b66e50f37d07460ece6dde461286f2a4555fec33f4db9df149da1b6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97274811b66e50f37d07460ece6dde461286f2a4555fec33f4db9df149da1b6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97274811b66e50f37d07460ece6dde461286f2a4555fec33f4db9df149da1b6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3aa0715b907326414af7c47fecc950bde8f0fe54b3dda80df00fbe216f3b125"
    sha256 cellar: :any_skip_relocation, ventura:       "f3aa0715b907326414af7c47fecc950bde8f0fe54b3dda80df00fbe216f3b125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "948ee84a09874254696344e98a7961486b840259ee8b33e6842351f387956607"
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