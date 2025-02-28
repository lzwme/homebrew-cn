class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags2.6.0.tar.gz"
  sha256 "077c7be4a91783d4bd727d19af88fe5906afd7e70babae9d88a3fb31dbd831a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b08a369ce65c1d8e291fe817272ded86ab253725d1861b842aad96763be2c436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b08a369ce65c1d8e291fe817272ded86ab253725d1861b842aad96763be2c436"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b08a369ce65c1d8e291fe817272ded86ab253725d1861b842aad96763be2c436"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b963a04cae24b9d21efa3182cfa4578dad2286a73ac436367fd9c597036dac"
    sha256 cellar: :any_skip_relocation, ventura:       "61b963a04cae24b9d21efa3182cfa4578dad2286a73ac436367fd9c597036dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf32b0c002bd0d951a94e1f1d52b17cb66cca75ed8f9f76a5cb7f749507479f"
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