class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.37.1.tar.gz"
  sha256 "2099386c6a053de7157e4abb20eb11d0e388770d6d990bf789e829dff64f1e63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "044f218fbbe611749095dd06c5a1c86e5879a7010aebfaeaa78d738ac3096652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "044f218fbbe611749095dd06c5a1c86e5879a7010aebfaeaa78d738ac3096652"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "044f218fbbe611749095dd06c5a1c86e5879a7010aebfaeaa78d738ac3096652"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "044f218fbbe611749095dd06c5a1c86e5879a7010aebfaeaa78d738ac3096652"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb023b9947d9dbbed7fe9701790896591757909029a277244d7d72f03c8bdb6d"
    sha256 cellar: :any_skip_relocation, ventura:        "fb023b9947d9dbbed7fe9701790896591757909029a277244d7d72f03c8bdb6d"
    sha256 cellar: :any_skip_relocation, monterey:       "fb023b9947d9dbbed7fe9701790896591757909029a277244d7d72f03c8bdb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d3eeffd003c0ffbee6f07885547efb7e60125824fff7a70a5efb0268bed2a9"
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