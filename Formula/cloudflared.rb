class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.7.0.tar.gz"
  sha256 "9cd1a2dd60bc5de88430214578c1c2b06d48548c569e144d1b995d57ccb8a0d5"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f20168c27cc097da2264f956a5d0bf75bff038507ff3d6dc33d20ac8ef9c74c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63d22ab4c7f9f0f89468c23d4733a87dd9b8da3e12b384344d0445fcf3a92821"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e61d2d78af4ebcba518610b90705d14c9ea6f18847c9a5eb841823e8e45f3f2"
    sha256 cellar: :any_skip_relocation, ventura:        "793f3fd9568ceb4be000f2b3bb933bae62b96fc10a13d0c37feba50091fbd2ec"
    sha256 cellar: :any_skip_relocation, monterey:       "638adca93356ef2a14aa36c533172ee0b1b6fe699e44bacb96edc92a771d944b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2047c0ce2ea82afad0acbcf0e873d049886e71ee9175546b2801bd4c51af0ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "545026d81fc92e6e9f223182d929ae373b6f2b48b9d55e1ea3b614c8db398611"
  end

  # https://github.com/cloudflare/cloudflared/issues/888
  depends_on "go@1.19" => :build

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