class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.7.1.tar.gz"
  sha256 "9eb4bd66888746fc1920bf98889b29c2ce98a7719e2c090d6b31740e397105de"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "371d792a553af0b474f218dced55c870a9ef1303c4fe9da18133ffb31b3264aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93df27994bddae6af75c4a1128f455922564d86074c926cc231e22dc40d3118d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9c8d23a6916ff73dc1174dc3f452e65bd65e83d9449717135ccd6117cc98194"
    sha256 cellar: :any_skip_relocation, sonoma:         "27fc7f49c5e8896ca353547fc310038c0d554a4c48343927271ac30e42b96202"
    sha256 cellar: :any_skip_relocation, ventura:        "47ec5a9d4525eb039154e90837028e63398d439095aceb7a0a8610652cf1d3f1"
    sha256 cellar: :any_skip_relocation, monterey:       "f8ed9597f98afc8af8542600c75661e7896ca7380ffb5c8f98a5ee29dccd5d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0bced1e408f56cdcfce3d6b3e474c624c7a8b66e5173795f583e5d9db0d5a0e"
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