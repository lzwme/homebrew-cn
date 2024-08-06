class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.35.0.tar.gz"
  sha256 "f3d789efdfb7c0cfcb4caf2395ecd131e6118abf0d12f1b4c5a4b88e11c9a253"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a42909dec8f5dabaa6f17807c9d128c57b03246ac8c6819fb41d2fd567c416ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e95d9e0a091982b6062218dec4509e82caf1b2bd70e4d4b24749048d9dab6bc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1f0872521c445a0334b9f2467672ab09706b9c0ef8ee1ba736fc62d4fad06fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "964250e60287b066bdd03dbb74e1027b4b915214b7ea7a62447e86051df249de"
    sha256 cellar: :any_skip_relocation, ventura:        "060ad064e65ce7ce8d2aefd6efaa11f3b5c375d6b4bf0f578dbaf170e6e129d0"
    sha256 cellar: :any_skip_relocation, monterey:       "e46195735e401793f2cf4c97fa94a6a966f95748c82bef622cfe4735f5d644e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da18fce278db752240d9425b27162f29c17833a54022d89435bc162f69518ea"
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