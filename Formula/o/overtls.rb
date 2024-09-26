class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.36.tar.gz"
  sha256 "866dee29fb8e91f0aa0c4519b96322baff7d1ad4ead583e4f7983b44583c5614"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b71a3829a395be20f964a36d75a571732522250b0d9aa4207b3ea2dfc1761bc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1903a526617c0b7a7cc7f82ddfd20be7cbb6df7fc75fd94d26f545a3380ab753"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62c1ca44db7e68951ba4ac248a1591ab63f02a2982208efa7cdfa2c7f2cd1758"
    sha256 cellar: :any_skip_relocation, sonoma:        "718bd5e54830b98d5c7d864237a5f82f5a2b593b862232eaba9904642072a6af"
    sha256 cellar: :any_skip_relocation, ventura:       "3032b1f3e8a2fa9fca572c354252afd69a7883fe4c36f2e87ce57a64fe7aedd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82fba844c70aaa432b506d02d15cb984c08c165819ee659f32db46237f4be68f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls-bin -V")

    output = shell_output(bin"overtls-bin -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end