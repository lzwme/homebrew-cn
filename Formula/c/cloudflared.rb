class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.11.0.tar.gz"
  sha256 "bef01251bebfc2ddf146388c5b771bb41cc13a29f79dd7dfc504e47a2f161b63"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ecd402f4ed52c392f3031a5881b5a974ab9084fc098bba46d305bdb561cf858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d562fce61f8cc939dbc30ff20386bf6dbca8edeb11a69bf5b008a02919643120"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33b923e16bcc933d7012bfb86f1768be75ef2032de9afdd9ae1fb40ddd9be7f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "be69a275abd6eef1345c7af8054a3afdd677878caa12a54e30aeed4547d6e6e7"
    sha256 cellar: :any_skip_relocation, ventura:       "201768af97086e62c1ebabc83f82cd9ca4059821812d824296e2337f95584821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da54a90782311b0ecca084c444f8304db5130864fa839f9f559b1024414b834"
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