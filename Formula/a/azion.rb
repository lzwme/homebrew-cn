class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags2.1.1.tar.gz"
  sha256 "fd4528c4c6ca4350287362019866921569f188645b3f11eceea2ed123edff796"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8573336d4c42699ed68422f54751617b1856a716bb8baefcb447e309bd5742d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8573336d4c42699ed68422f54751617b1856a716bb8baefcb447e309bd5742d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8573336d4c42699ed68422f54751617b1856a716bb8baefcb447e309bd5742d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7e963621df1b482229095f519c929ca0bd5ea51bc495cd2bb3635bc10b19470"
    sha256 cellar: :any_skip_relocation, ventura:       "c7e963621df1b482229095f519c929ca0bd5ea51bc495cd2bb3635bc10b19470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82246d510bc1a22dff27b904314a8e1645c8cff26f0815499ceb3359963cca80"
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