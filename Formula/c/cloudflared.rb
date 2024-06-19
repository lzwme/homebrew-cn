class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.6.1.tar.gz"
  sha256 "c61ef286962c3bb9c5edb580b89dbf8293083fa09a8f0f59379fe8ec2d04cada"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ccdb4510bce9ad13b23e9b810034468020dbfcad11124cc19d58d3b608e3a3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b88dcba08acde1b380acd81458aa448caddf89829aa4a184459ab3725cef592"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b4a2e0e381ed79bc4dfd8951cc6b8e64bbddb572f4369874a58385e663691ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dd612612583e2701325eec510b28730d9d818a5026ad4ef74d8e13fb1310345"
    sha256 cellar: :any_skip_relocation, ventura:        "70c745a50281371c576dbdc1d4275131a33881323e0ef0e0752b213f176f8e4b"
    sha256 cellar: :any_skip_relocation, monterey:       "77d5add5c9a8bf5507bbd87aefc3bdf8ab2ef05aa31cba45a70f10de6de2e85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f401f545433b919d50b0abb172571193004309d477598a2631bc97c81958a995"
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