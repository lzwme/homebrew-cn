class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https:go-acme.github.iolego"
  url "https:github.comgo-acmelegoarchiverefstagsv4.18.0.tar.gz"
  sha256 "850bc2db37c3ce33837e5c9f18b2b8f1b2a45c07fc6ef13a4539f8f871a1aad3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0fd2c3c25218584e4a20655ce88232b6b58dc45bae9fa1f20062c25eba7d5a84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44987645e9f136c74b3c8c04a2c5686ad5200149585ade58914c991e4133b187"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44987645e9f136c74b3c8c04a2c5686ad5200149585ade58914c991e4133b187"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44987645e9f136c74b3c8c04a2c5686ad5200149585ade58914c991e4133b187"
    sha256 cellar: :any_skip_relocation, sonoma:         "18fa802c033e4071ab8c6fa9ea603aac1c2977da13ddcbc3f2390ab3fac8da6f"
    sha256 cellar: :any_skip_relocation, ventura:        "18fa802c033e4071ab8c6fa9ea603aac1c2977da13ddcbc3f2390ab3fac8da6f"
    sha256 cellar: :any_skip_relocation, monterey:       "18fa802c033e4071ab8c6fa9ea603aac1c2977da13ddcbc3f2390ab3fac8da6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e7fc296687562001ae802a58c16181806604bb65d6d655c54382bdb8275cc55"
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