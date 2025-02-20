class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https:github.comcontabocntb"
  url "https:github.comcontabocntbarchiverefstagsv1.5.3.tar.gz"
  sha256 "d7320abad0c67e0b22bf008e7efba0ca55c48838d42b6ae3bce2e9bfabb96ec6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d1015034e1cd267b3a8ca19c2e130b5813924706a69997a9106fc6714905222"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d1015034e1cd267b3a8ca19c2e130b5813924706a69997a9106fc6714905222"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d1015034e1cd267b3a8ca19c2e130b5813924706a69997a9106fc6714905222"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8b801ac1899bd8b2302ca19d2c19b4221b3b5f56f303c1459ec16608fa3336a"
    sha256 cellar: :any_skip_relocation, ventura:       "b8b801ac1899bd8b2302ca19d2c19b4221b3b5f56f303c1459ec16608fa3336a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c95866891216ebc9cfd7bc5e88987fb8b3d5887a3acc1b9a1c7318b205ccdcf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.comclicntbcmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https:example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end