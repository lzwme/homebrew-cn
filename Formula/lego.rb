class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghproxy.com/https://github.com/go-acme/lego/archive/v4.13.1.tar.gz"
  sha256 "2a75a0dde1c7e57d2b3972ce4381bb5bbb450ae6fda5d366f54dcb599a665230"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f75f6032322cef9db4a10cc1825eafafccca1c98b7e6dd2237ab4874a6614d49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f75f6032322cef9db4a10cc1825eafafccca1c98b7e6dd2237ab4874a6614d49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f75f6032322cef9db4a10cc1825eafafccca1c98b7e6dd2237ab4874a6614d49"
    sha256 cellar: :any_skip_relocation, ventura:        "9382c49899d06b6b49ec5479d978d29e48050157ab4d0032fed5bf40a6105754"
    sha256 cellar: :any_skip_relocation, monterey:       "9382c49899d06b6b49ec5479d978d29e48050157ab4d0032fed5bf40a6105754"
    sha256 cellar: :any_skip_relocation, big_sur:        "9382c49899d06b6b49ec5479d978d29e48050157ab4d0032fed5bf40a6105754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a673e193b2d35cbb26e784c39c1b2686e9a57907031d9589a0d761c2c3383d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end