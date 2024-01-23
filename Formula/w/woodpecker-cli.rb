class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv2.2.2.tar.gz"
  sha256 "505cb03b59269a1be072268a8aed416f7c24d0294db5bdddb7e8d8a33e27468c"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c17edfc2f0ac441395bff1a52cff927d51461c10f2e21e234ec3a39a9bc0583b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0506f3b1943395c1ad76ea757ac99d6caa0120ba28b99803a7b32fd8ddd954b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8bc34a55a53a93326f85790376a901194f849916c40dfad624b8727e44029c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "65a0cb1be91d07f1f5ccde6438210874f69e173d4d703695e90b85bf1aa0641f"
    sha256 cellar: :any_skip_relocation, ventura:        "9ef087b5c4f760cbe90687dccfe85b8d84e50fe0505b9f326bf4772b6c8e7b90"
    sha256 cellar: :any_skip_relocation, monterey:       "29199d870f9178f5666c1c21d7325f293cfa0839b778e52226c3f8178674f475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa860a27228a6d9555fdc71c62e941809610be14f306b7b29b44bcd49d5022f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.orgwoodpeckerv#{version.major}version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcli"
  end

  test do
    output = shell_output("#{bin}woodpecker-cli info 2>&1", 1)
    assert_match "you must provide the Woodpecker server address", output

    output = shell_output("#{bin}woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}woodpecker-cli --version")
  end
end