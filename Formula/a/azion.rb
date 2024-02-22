class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.13.0.tar.gz"
  sha256 "a5132404261affee5b6089c667c348e01d845e671942abfeec46f1a4231dddb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df0296dfc6fdcf4fc0ce9afed2a267e88cb97a89cae68f01352480af189ee49c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2465e572d4163b9c6e07631e5603179d8eab15d03e15984e7e161ad0d4aa4567"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05da0ab8aa3184407a0e8fbdaa492344abfe6b62b7c2073b1e92fb1e5f9a3c4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2dc593e330acdca71bc27b207e6a25eea40f51c098b80cee09645df4cd37477e"
    sha256 cellar: :any_skip_relocation, ventura:        "6ee0a6a682cc6b7f2e8f90ece407d380ade902ad1f542e425f8bd9066d0f4dee"
    sha256 cellar: :any_skip_relocation, monterey:       "915b70f393fad431b3a43a35409c37b1ef6ff4a2afa82bc4373ccec73de5b5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ebfa3aa1be17f98d3d71b3c1ef65ec6105afec5f864793824adf2d58540dc36"
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
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdazion"

    generate_completions_from_executable(bin"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}azion dev --yes 2>&1", 1)
  end
end