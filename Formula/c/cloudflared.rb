class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.8.0.tar.gz"
  sha256 "37844b536f40d31d2eafa62c7d2f543d8ec23cf35185f3b0d2b9d0a72cccf78d"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ab052349e9c7f67f15ada05b3d84d88ec9a0dd78bd0cb720a3baad681be8460"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5f16db09765efe246c76645577862e9706146e57f1ce2e5112e71fa06ba7257"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8e1491cc07863839b937bd74b1d566414622f8474807cc98b1d87064b53d73d"
    sha256 cellar: :any_skip_relocation, ventura:        "eef74aba662ab58805489c22ebb28adffbc1e4ac9393cf8fbb9ae3b92dbde4f6"
    sha256 cellar: :any_skip_relocation, monterey:       "cc440531d4faf7313f4cbe85ac44d269a5f35c13836e03e75787309d212db15a"
    sha256 cellar: :any_skip_relocation, big_sur:        "751332d986bdd64fd227d9189d9bf8a1c3f14f30f757c6f5a7b0ef09ce2bc602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c641c375c81719fcf6cd03914ab7240a5d3a3c983951b5950bf1f78673926cd0"
  end

  # upstream go1.21 support issue, https://github.com/cloudflare/cloudflared/issues/1054
  depends_on "go@1.20" => :build

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