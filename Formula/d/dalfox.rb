class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://ghfast.top/https://github.com/hahwul/dalfox/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "277b98f2d2f75380292d8888d0f3e88d87b0a35dcfb510f3be5a17cb4d3a4186"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a244d1d75119bae8576a26666930c8d96a30a1d6c1519c49f42180d2fef239fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541ecc5f7cb8fa98797707eda4080a51456af5cd326b4e0c5e25993fe045ec1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e37a3e7aeab1d38bf0c741b45b7573e39a5bfb63c4e2d14ddd61a2d3da8a60ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "41ceae37d8e44bcbc4cd10b68600407bbd574c7e12c4fe42432221072f75c18b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60585d33364d61e3f7a810ad2924f191db881d2f23eb159de70fb5b37bb2d843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9348b0a2851d47df121565f2d7d9e63735716a840b9488aaa2efb0c502d8162"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1", 1)
    assert_match "scan completed", output
  end
end