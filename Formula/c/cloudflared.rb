class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2025.2.1.tar.gz"
  sha256 "c82ac315fa081cc18c98c9f63657375151a8c6141e7597d794232a1d35f93a4c"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fde57b51b3e52ff99969fd847beaf0823679dbbb4f57fc81047d13154dd0989e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f45f0d1518cb5b7a0a2cb295326abbd2decc1d567f541fff57f123c52ad2781"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "106dea7b437a67d094ccaac4a6419e846c48d50b94d168eebdf5a22888cfebe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a3c9fab166687e7f0f4d0962a89ba6ec273122a358caa26030abf64d0130af4"
    sha256 cellar: :any_skip_relocation, ventura:       "9599deb914028b2cca161586ff520584df03d87aec4d5253cfaf3b7c20b12673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e26bafeb415f7e0d51fd67dfa6a1c045ebd0f39465f2c341788cd54f2cbf8c8c"
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