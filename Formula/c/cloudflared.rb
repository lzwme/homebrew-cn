class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflared/archive/refs/tags/2023.8.1.tar.gz"
  sha256 "e2cbb89bf73220a7bc4491facb96ff16c1880ebfcac679b5b17f21abab039c72"
  license "Apache-2.0"
  head "https://github.com/cloudflare/cloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c67f2ada20d4d2c47523a3c01390c3a6803b19a824a495d909c1d423ae4e068b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caeaf3716fcdc5e059e1fbc542e6526beb0a644bab08e9fc89f9cda7ce965d42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "543565ce667092e4ffac69f2bbb5672fdd5d45f49e0cce970a21aaeb0607b068"
    sha256 cellar: :any_skip_relocation, ventura:        "88c1a81ec8d04fe7e1dde7257a3f60f0350e7badc2748c75398feac81da6e893"
    sha256 cellar: :any_skip_relocation, monterey:       "729631b4bf0641afab6cf4e6eb903d88c0bc52c994dafd7a65b30752086ef7cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa454c66bef57b5bdd0e1074af70f989a32683e35d70dd1eaaef9bcbcb7835e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6386fdd9dfa1441082d84f1e1c61b44818487d793a9c167223b9772b78e0fa5"
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