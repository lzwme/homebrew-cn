class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.17.2.tar.gz"
  sha256 "c18e6bbb7d93b6effe52cf0aa91479be745930bed039c0464aabb74e532526e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f842e9fe5c8ba1f34f105225930e34957f6e0ea28a817332cc19fd15e85779bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c74424bc44320acf96107d2aa8fdfa433e5d877f58bd8ce04c39055403b82a02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bba70d06f6fedf324bd12c9049cb32521a518b6bca76c6d36b5c6aa2a5d41bd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9fbdbacc273875c0e9321533612998b9153402f65d1bf5465db4cd608a25799"
    sha256 cellar: :any_skip_relocation, ventura:        "6a7f8588a74f13390ae17debcce3e5426b1b5f43215bac88da69098b0f1b0a7d"
    sha256 cellar: :any_skip_relocation, monterey:       "c70eb7538b9b11ea2cc03031f83c050eef917c990bcf6b9c54218ca09de381cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26a875ba287145c99d372a331c0c4a1af4e4f7f1144c5779b94889e885691943"
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