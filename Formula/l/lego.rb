class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https:go-acme.github.iolego"
  url "https:github.comgo-acmelegoarchiverefstagsv4.17.3.tar.gz"
  sha256 "79ad0baa3a1bfa36c8fa8a3b5f497669f65ed1b16addc8ab1b04f0f23723ec6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad3ecd7aa4adec1496bfd018281217a34d2635b4882d99cf77a16f926453300f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "550bb43a26c649b92a526e72b83d39afbdca9349ab26f86b2e1449852004d111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0d4bdde43df4f8202ab213fde2389c5bfcc2f3f0fc0fdbe5dd7bb6d74d2f055"
    sha256 cellar: :any_skip_relocation, sonoma:         "462745f2a46f5584a5e387ec3ca48a0e9c0d9c54e4e2df7cf718af7de40bfdba"
    sha256 cellar: :any_skip_relocation, ventura:        "23a30e6d9eb56dfb753c1b7a67c7084adf2f2cfd9654c6de2e6562f14b9866f0"
    sha256 cellar: :any_skip_relocation, monterey:       "99e1690af3f0a2aa7b65a5747d5353660b6d7b692e3ea05bb9118531381b90a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bb1d18ca98322d4a46d748bbf6ecbc0d253f9b04d3b5ded93e932a1e8cd9f4d"
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