class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.38.0.tar.gz"
  sha256 "0468dd41094895eeac321b4dee3566927b90a4ed04018422a08cd1624b1cfa46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1319232e42e51f4a63e92330f8edaa682463be43040acb3b1ab5276d92f40bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1319232e42e51f4a63e92330f8edaa682463be43040acb3b1ab5276d92f40bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1319232e42e51f4a63e92330f8edaa682463be43040acb3b1ab5276d92f40bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6506bacfe1697cb48e3b9bfd081975c33a71fb453ca34b0a148e59eeb5c7354"
    sha256 cellar: :any_skip_relocation, ventura:       "d6506bacfe1697cb48e3b9bfd081975c33a71fb453ca34b0a148e59eeb5c7354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9d0f846ba590f97bbf5f30372e133884665f4d607b4589da3df951eeb2b930c"
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