class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https:go-acme.github.iolego"
  url "https:github.comgo-acmelegoarchiverefstagsv4.20.4.tar.gz"
  sha256 "ae4ec098b583ca4317765defe0e654fc54705a83f661455c30042701b7597fee"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae4b6eac5bc49ea5e42f4c10e4b830c51b3b7c855d5152f4c675a53ffc214690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae4b6eac5bc49ea5e42f4c10e4b830c51b3b7c855d5152f4c675a53ffc214690"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae4b6eac5bc49ea5e42f4c10e4b830c51b3b7c855d5152f4c675a53ffc214690"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3486c5bc8dd78d6e8eaef7671849eb1a58588e701dbbf010afe06c7ceff02ac"
    sha256 cellar: :any_skip_relocation, ventura:       "a3486c5bc8dd78d6e8eaef7671849eb1a58588e701dbbf010afe06c7ceff02ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8510b1d2f30d898dd5be4c4f9e05c881efe612ae4ff1191545c70eb06f5eb1ac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdlego"
  end

  test do
    output = shell_output("#{bin}lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}lego -v")
  end
end