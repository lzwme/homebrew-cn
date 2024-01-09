class Cloudflared < Formula
  desc "Cloudflare Tunnel client (formerly Argo Tunnel)"
  homepage "https:developers.cloudflare.comcloudflare-oneconnectionsconnect-appsinstall-and-setuptunnel-guide"
  url "https:github.comcloudflarecloudflaredarchiverefstags2024.1.0.tar.gz"
  sha256 "14ae1967ccd4bf59659152988557e08adb284029d1e8da62f116e0372d1f31d9"
  license "Apache-2.0"
  head "https:github.comcloudflarecloudflared.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62ad39491f9b4b1ac1325d2d91d4743f98f18f5b9c34c72e81379c03a1ff0315"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eebe7fa2357b59f9cded058f49add82296592887903b31cceb83d42a907f02ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8472404d56f3a5030bb7eb07df66014c682894c8fc7decf5d6de8c3102d1a6f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b44e230229ce5b60ef6dc35593860708cd5161e8b8122ba72cade79a8ca10596"
    sha256 cellar: :any_skip_relocation, ventura:        "0611b9648159bc4fae232978984225506cef0da535e5dc619648fefe300c4d83"
    sha256 cellar: :any_skip_relocation, monterey:       "89e1361c43077990d081d1463500337f0980649c71d72a1c12383f8be070cd98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8ae35c8b740afc7efcdf5db7e29c3b99a75c1211372451875b14664b3a876b4"
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