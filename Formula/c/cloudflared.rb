class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.1.3.tar.gz"
  sha256 "5a7b986493baf54f4d07508d4537c165d990dfda93fa453afe1792096bd4c285"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "956ab830836bed6246fd3c4834f7ba24a596a14241e25aa7c74b0e3aa4dab4c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c22b56efdc2d644946b5d39a2f97999f49aee3c3eae0d856f62171084a35e061"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6650b0b6098aea9d2c7b1035450d31b5d79e5a2e1d98b859fd3a81b5d0d1492"
    sha256 cellar: :any_skip_relocation, sonoma:         "deeb3771a015534043f99e5dafefa5c910febbfdc25f04562caf5a73baf52198"
    sha256 cellar: :any_skip_relocation, ventura:        "73726795b5e8fa21a6f64c036b736ed338d1f754870860873e1c11f40c3fac54"
    sha256 cellar: :any_skip_relocation, monterey:       "b64d4c2f23110f2814123e4a8a58783b133c87d553c3a7a8370c1a06de7e1829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441fdbfa2f04de62eee1478036976b0bb1bb074bf328caf453c47104e05f5574"
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
    help_output = shell_output("#{bin}cloudflared help")
    assert_match "cloudflared - Cloudflare's command-line tool and agent", help_output
    assert_match version.to_s, help_output
    assert_equal "unable to find config file\n", shell_output("#{bin}cloudflared 2>&1", 1)
    assert_match "Error locating origin cert", shell_output("#{bin}cloudflared tunnel run abcd 2>&1", 1)
    assert_match "cloudflared was installed by #{tap.user}. Please update using the same method.",
      shell_output("#{bin}cloudflared update 2>&1")
  end
end