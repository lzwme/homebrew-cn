class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.5.0.tar.gz"
  sha256 "38d72e35fbb894c43161ee7c6871c44d9771bc9a1f3bc54602baf66e69acefd3"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "509fc5fa0ccfdf22d9f5e0a952a77609d9592fa3cc5682d20333e44bf4113e42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c6eb81dbe015b9b0cbf7dc82f22ddbf2fce36c5c29ac60372e2163dc382a023"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b101e13fd4e10fd44d7624703b4b7678316dcc79de10b7442309effa15696e3"
    sha256 cellar: :any_skip_relocation, ventura:        "be7552265f49d1cdedf0bc768e190ad833508a2f50d15e1219fff5762ff9698e"
    sha256 cellar: :any_skip_relocation, monterey:       "8d5acf2609b5d55e8d7e8efe6bce0094b6dd326affc4d2963add1c77ca1e402d"
    sha256 cellar: :any_skip_relocation, big_sur:        "89da302bbfb2628b311fd593f5a3f705aedfdbf532b7b9b7eb0bc0bc51fe9729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dd892c3f28c4a81bc56b6810c2b3d52bd54937bcbf383f6e9fb9fa638b8ea66"
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