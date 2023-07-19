class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.7.1.tar.gz"
  sha256 "0863eadade6c6ac5838510d8fb514ec2332bb79bf54edc34e90cc79652b6c816"
  license "Apache-2.0"
  revision 1
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af64b6320d73210f3f9dbbc733054d9ce73117923e3171fc27b2a21c1f02e88a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7819d9d37ec9886f9270ffc026df590cd6638df976ed96c18b4082c8bc4e2a91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7042951bdd5a87e0dc0c319feaca76d3e66189e52ede39c702259e75b779415e"
    sha256 cellar: :any_skip_relocation, ventura:        "b3d7529639f203b2de95263f5ffaeb13665ce706e983477de42e43b821ca2346"
    sha256 cellar: :any_skip_relocation, monterey:       "3e35744baa66a03f219e2278b9a50c72f776f71ed8dd78dfd6e35c0feead7bf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc53a2a2a99240b4a85809f74c7ab420612e11ecc83f028ba20c8d001ca611b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59ca0d7cc4dcb2c11ef9ae81b0421b528dc0b39eae6a40bd956714d9c9fc947b"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  test do
    help_output = shell_output("#{bin}/cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}/cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}/cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}/cloudflared update 2>&1")
  end
end