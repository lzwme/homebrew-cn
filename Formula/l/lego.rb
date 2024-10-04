class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https:go-acme.github.iolego"
  url "https:github.comgo-acmelegoarchiverefstagsv4.19.0.tar.gz"
  sha256 "3a880f4351fbf023196469ee7dc914f953d59617f5abf7d816f0c809dfb71bb0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ef2ad18641bbda8e242ff5dc65a02f125ef68a280a4e272a1dbdfd8347d7b95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ef2ad18641bbda8e242ff5dc65a02f125ef68a280a4e272a1dbdfd8347d7b95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ef2ad18641bbda8e242ff5dc65a02f125ef68a280a4e272a1dbdfd8347d7b95"
    sha256 cellar: :any_skip_relocation, sonoma:        "df58bd49c533a9a0d10cc312e393705fae887174f4734d3ca4945955f71fae53"
    sha256 cellar: :any_skip_relocation, ventura:       "df58bd49c533a9a0d10cc312e393705fae887174f4734d3ca4945955f71fae53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5466482613a44073a1f521e655323964467d8f4363e9061c00d9dbc0318f7d6"
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