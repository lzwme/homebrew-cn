class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2025.1.1.tar.gz"
  sha256 "37913efe6b7aa3f84fbffc53f0f4a02c6e4fa587049c422eb27fdc452b624725"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67475a0ea010bb61db19c7a8018516a4723301db8dc7c1dc41ea0a9a9d94aa37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77c6a09fa5335880b51f768634a654dc8709414027020b4ddef425809d45a302"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a313af4aead3971fd2651c524beb5f9b588cefff289f55d34179dba1b0eb077"
    sha256 cellar: :any_skip_relocation, sonoma:        "cad508ee580678cef03eeac783c9c93a05a736e35064c3c5cda1cbd4602f75d5"
    sha256 cellar: :any_skip_relocation, ventura:       "05c45979b3ae91597bc640a3aa389374914e963480c2707bb63d906b179caa8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c46dc67d60b01bfdb2ba289d2f613dfd77f75ab953c5fabcf1c394908991b8c"
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