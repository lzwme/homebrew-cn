class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.7.3.tar.gz"
  sha256 "cd25a0f6ed3b636aa8de163d25136cfa8ebc6b33ba52f98effb0c0768205307b"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5473419d9712e4a81a2d1488c4f60fd4b1ff2e795f18c67719c6649e49fffdc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c86ee5588969968ea7021fb92163982fb2a36828622044bcdb436c8ff3492ee8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "365114b99396c2e26ab119a38c20c90d44e3e372a04ac4ad39a5656d092eae85"
    sha256 cellar: :any_skip_relocation, sonoma:         "9502e1be8694efa5e412d498295dc3bcdd2ef258275cf9f08c24ab7b479b3de6"
    sha256 cellar: :any_skip_relocation, ventura:        "021cc7beb5382a8fec390aca515cda50d62e08a1f3c6ae4e06ec660c38ab5940"
    sha256 cellar: :any_skip_relocation, monterey:       "3e1224e4362059b34cfabcca8b0e3906b00d172cc8bc534dce90583dd08c24a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d3c6915a908d5fc81e69eb9757721ef2d00a2cb33726974ae80ba1f50616551"
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