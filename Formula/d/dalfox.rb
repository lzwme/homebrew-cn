class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://ghfast.top/https://github.com/hahwul/dalfox/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "80acd23eb5c5b405930e82dac37645ffa88353f043a752795d82de87509679ff"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f124f58ffe41ed091511d9b802e2990b024983817e0c6cf1b32217b1dbee269"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d0d146eb4b798efa50e3ffbf50fb44d39a6473d0e367e0a5e96983f75aff45f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ccf5b1502ccf8985e0968f16b96fb898d1e2b1f7c2c6974be8dfe6dd2e12664"
    sha256 cellar: :any_skip_relocation, sonoma:        "e80c43c1a8da004ac99c7c1e8fdfa5973c261ccc95b5afe88f49e08a016cecfe"
    sha256 cellar: :any,                 arm64_linux:   "58f3a0ea6bba7bc961ba36cb268ed2363aea2b12fe7b9de3fe836938c19c784d"
    sha256 cellar: :any,                 x86_64_linux:  "1949296af2bb045f7c3f0f395666e8270a9eb3b009bdbedd1e3ed28fbdeb57f1"
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