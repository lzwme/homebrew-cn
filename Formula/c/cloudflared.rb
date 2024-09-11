class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.9.1.tar.gz"
  sha256 "f96b703ea848bc538322eb957749b0b2395e0cf83213cf310cbde0a3f598eac4"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "45d326ee33507859d8cb249236028c5cdc7a491227df0b8b585dfc08807cd037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05c10f4b726b60f73585d46410b15903dfb7bcc96b66464f31cd6c77d477e653"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa0a9a1b189adaa0944947f14893520c818f397c3cc341447a0885226394e985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa7d904c249e69c1f0856e391a325d45e46beed1e37f9bbf14b745ef8a4b7e84"
    sha256 cellar: :any_skip_relocation, sonoma:         "83c6d6db5e56a07574eb26c2da4e7610a6f97497b6a5909512104536f64fb6a6"
    sha256 cellar: :any_skip_relocation, ventura:        "f76e02230b3427029d92e25c0769361ff7d0ad018b5e369efe8b3e013c3b69e9"
    sha256 cellar: :any_skip_relocation, monterey:       "79e535688d7626224685202e26e76574f7ed24d3665984ac68ba81fd249045e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f0a869e54a3e008315d9d9dd9557d68b104c15744c35a324b43f8e1f9da4d7f"
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