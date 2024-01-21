class Naabu < Formula
  desc "Fast port scanner"
  homepage "https:github.comprojectdiscoverynaabu"
  url "https:github.comprojectdiscoverynaabuarchiverefstagsv2.2.1.tar.gz"
  sha256 "d357e05d14934e7ac60337d8de5854fe15830565abf8c543d3273c5bf3676648"
  license "MIT"
  head "https:github.comprojectdiscoverynaabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0026a3676ffb2f8455bbd22e18de4fd56fb8407af5352d8ce60dc28f7237198"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9206ae47f18f55ee68d2cd21f5d90b806f0c06d4c89258cd2c31e0fb64c436cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2154c6818151c5e7ff28ceda08a75b367be4b1b508bdf47abbd51cea63b0bf8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "07948cc7a8d43ab617847b31d2e2c5f1dd7bb2ae5aa6608d4ee3190a69b2ec3c"
    sha256 cellar: :any_skip_relocation, ventura:        "5d087d29b2ab941f05f8ad59bec1c5d0043a07b45db938a5accaf3409d11563d"
    sha256 cellar: :any_skip_relocation, monterey:       "d82e95ba1c714a963766accea260cd39ec874b02f53b7630c773998dcafadac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d1585e8219128347c3d16829a1b7238fa3da4ea0ff04295811b245527b6e23c"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdnaabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}naabu -host brew.sh -p 443")
  end
end