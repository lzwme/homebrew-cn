class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.1.1.tar.gz"
  sha256 "4a0661d731c35d1273b1a3eff7d44694fdee4755912495fd870ec8265da984bd"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad7c1c085e85c7464e8fcb9996913ce72be241a82e619876797516504b643f40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a351369885c79a6e9b2ef8242d3717752b865b450d0877d9452d594694ed8095"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acecf28cdbdba1541f3cd2bc398c43bffb0318a04bba7a3772db7f6058e2672a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ba31a6057d2d8e81c27ee98d52d7d0327036a684f693bd363586e35bdc20650"
    sha256 cellar: :any_skip_relocation, ventura:        "9638788ccfa5c970a5284fc3b22e2874a397f14022c8e858ff78a96806bfc88c"
    sha256 cellar: :any_skip_relocation, monterey:       "d7b8e010309323a0d96b18951258dd99ac1c1bdd56d7aff3cd8d54abd7ecf6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b88b96dcab25a3f6804c420dc3917fee4db89e754cb019959869224152b6c6f"
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