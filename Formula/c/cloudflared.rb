class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.1.2.tar.gz"
  sha256 "244455f69a9575fbf8f7a818eb71ebcb6a06182b5f3e1a757174418a3e08e1e9"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42943ea32da69d0f9a01e0dabad395acb6c112f2413f55d1e5857bd6b83d0750"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40ab2f9f01d529a2c8e95da4de716cb4af15780b74aecfecd6e8340b26be6ea7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f33397c18f2fced61f18e34b0581cd884ea5690a1c60d1c8bb1081692f15d80f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ec1074de186d6dc4d9ba6885b0621b3c6f914417c626bdb7770091ad58fb842"
    sha256 cellar: :any_skip_relocation, ventura:        "b23b8cef4fe1e40bfbbc0c17b4588fd0aeb3b7bb5a761d2ba771d8c9771ea7d2"
    sha256 cellar: :any_skip_relocation, monterey:       "43b61e445a65f4895f9cf3a9cd9625618e60939f3d92eb9b55d3ca106404ae76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bdd747cf464cc371c269ad65f80e4102a003c81e36ac1ded777a45786bda9b9"
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