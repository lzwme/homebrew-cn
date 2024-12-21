class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.12.2.tar.gz"
  sha256 "48b9c54d79419d0489baadb8cb54d5196e0ff17650fb9eff81de02989fa8b009"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0613f3fa220bd00487a3b799f7c3c28974885e377aadf6a0ead3498d9813ae1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a87f2b2dfca2f13b41c30c45976b6ed2ac925c3e8c47fe4d3eba564679d9a444"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "615399de85796b077a4cff85bd8325f3e386a076740e452d78ec44072f82f8da"
    sha256 cellar: :any_skip_relocation, sonoma:        "f90ed3fc6d4ef51ffb580d3cee90968b32191e6e254264dd911ee4c6efbbcc34"
    sha256 cellar: :any_skip_relocation, ventura:       "1a42e4e0b233a68deb660ceff094a7ddc9148a5e1a94bfe06a1f6813f263eb70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d183826595ba2a0966d9132020c25faf097977ac78caf0d2130d1b63078dffc"
  end

  depends_on "go" => :build

  def install
    system "make", "install",
      "VERSION=#{version}",
      "DATE=#{time.iso8601}",
      "PACKAGE_MANAGER=#{tap.user}",
      "PREFIX=#{prefix}"
  end

  service do
    run [opt_bin"cloudflared"]
    keep_alive successful_exit: false
    log_path var"logcloudflared.log"
    error_log_path var"logcloudflared.log"
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