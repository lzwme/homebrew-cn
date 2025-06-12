class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags3.3.0.tar.gz"
  sha256 "eec46c72a4f231a7ddff6898dfae5a33b3c30f622bd87a6ef4ee156bba9e4f4e"
  license "MIT"
  head "https:github.comaziontechazion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "646daedb56844f48e097ac460b2414b46c08d8418c7235de0bdaec0b61efdcc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646daedb56844f48e097ac460b2414b46c08d8418c7235de0bdaec0b61efdcc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "646daedb56844f48e097ac460b2414b46c08d8418c7235de0bdaec0b61efdcc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c4f9bc65a412bffc3863284ad8333664c5ed82f81ebcf60169bb0f996287eb4"
    sha256 cellar: :any_skip_relocation, ventura:       "6c4f9bc65a412bffc3863284ad8333664c5ed82f81ebcf60169bb0f996287eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3448830af78299cf31bba42212102eac7beeb16a6b197c32f3685928f54ef80"
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