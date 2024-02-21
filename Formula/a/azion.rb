class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.12.2.tar.gz"
  sha256 "197bf2d07af883f9d9caa2b5b6c0018dcb60ad9e6fb14d1ced091296256713e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea3143fbf8afcc057a8819a51ae9197fc00ce4cd7786f8608d2ee658968f6ddf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3209023644ee480b42c13f4a40349432d3c6c6153eb410cea22b2f33810a022"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54901a7e8bd2fda8481e23d15f731a109e83d94836444b0c47f3c87fa2420d99"
    sha256 cellar: :any_skip_relocation, sonoma:         "70f59f60fea9c95cf1a5471bdd52bb1f6321c200933ddc67c78e20c14514f89c"
    sha256 cellar: :any_skip_relocation, ventura:        "9bef4bf040c7fc5c86c823adaeb4e196967af20cef0b2b776b07e4664f8d7b47"
    sha256 cellar: :any_skip_relocation, monterey:       "d33b1f9da209615e74f2731a88efdb16727f55dffc72ebaec044dc5da8881815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f510ad5d828fe8e1b1a757c0a48522173ede427d27f0b376c511849b35b7976b"
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