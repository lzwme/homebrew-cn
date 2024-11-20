class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.11.1.tar.gz"
  sha256 "1bf729c225701f6864b31bb6c251293caa06f9f1a6e671f3326dd20c3c9719ff"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc09eb8b677d672577e1ed2fd36afd0145dc332ab9ff15eafee7525a0ca6c8fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7247b8823d3308fc067a5c3fae0d3d6d981f08bf3d6fce2f240d73a32e92894e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc10590791eed97736281e1fc971ef45bf9245e2d1dabdc0b084308a3d688a8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddc4480753d9236cc8f92c8e63859be54490a8c47f823beaf3814c18d0a1fab"
    sha256 cellar: :any_skip_relocation, ventura:       "ebcef72c9affd47a05524527507ce6756a5844dd676bb3e8d514c92e41d12128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b46a2b27b98b82ae0536890828aacffd0b8a272d4cbc858ea414b97be902bff0"
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