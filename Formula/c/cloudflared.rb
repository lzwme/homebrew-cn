class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.1.4.tar.gz"
  sha256 "a78af7d12b96bba691c420bc0ea42087cda73463868a3ba7c6890a9f962218e9"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d004a7e5f1d6b2f51323913239a898b01352b4db13472286cf677da01880702d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16292770f1d56f0221ca695be6d4bcf5ac5ef39360c0ee09c6a18cefda5afd99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "727395c25a1f4c3f1c0028ceea1c8d7e006c19f941d446e6bf87c220c3b91e08"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b79b1689333902542ee43bea513450442956706bc9706ed274809425ac90d5c"
    sha256 cellar: :any_skip_relocation, ventura:        "904b3f1d1ebea1ddf5181a23a8fcf43bdbd42b7a521f8d5fb6ac48d08e452950"
    sha256 cellar: :any_skip_relocation, monterey:       "5a019ed2bc0c19f8184cf67ae9cafb5c79da5a9051cf8e089930028e42702ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e95f2df93bfe7fbbc0518fc0b36ccff370f60e75068e52730d0b669e19e068b3"
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