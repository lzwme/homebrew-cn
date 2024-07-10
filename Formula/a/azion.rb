class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https:github.comaziontechazion"
  url "https:github.comaziontechazionarchiverefstags1.31.0.tar.gz"
  sha256 "0661cd99bc233a7e4adc6e4625f7e82fe752cae291599ff85c56de558110afa1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bba78869d569aba57cbbce3716bca4eddf41e5ba22b9ff769d8c534285e3ca5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3377f263150a5461287435f946506bece1520c70d8640985298bb2db43b5fa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5abcf46fd564a8f5706a3ee26a6715ca094ad6f4625b9224acb38f111a6f7209"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bee30d9b4562dd719155f70a0963a281aef97b99ad26922700bf0a0cb3549da"
    sha256 cellar: :any_skip_relocation, ventura:        "ffeabaaa3ff4f6efae8f681caa3f62ed46598818c55fbcd938e3900588f95060"
    sha256 cellar: :any_skip_relocation, monterey:       "7d25f7e73a8e92194efe9f4dd94333361aa9993f72f473adefff5fb1cc08ed35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fcdce0eafb5b30f02c04d95ea611689b37340fc393c67d3060ff40f2bcc4919"
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