class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://ghproxy.com/https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.5.27.tar.gz"
  sha256 "0376746e300c3fe64da2bc482dd34ebd8353a959654dc12336c920b6546bb482"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f041624caab3a3334fcd2ede671197bf107b22aefd67dce6d4c9c23bd539131"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "583a2e3326400d076904594d870d3f09034a5aca914f5ecb1be786759da5bb3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26b02587b19c1a2e63f292b2c026bfc8af817da805ac59437f9f72187bd68fe0"
    sha256 cellar: :any_skip_relocation, ventura:        "412ed9aad52a81f7a1d5a96d08ee5f033126e2baca793aca7a544f14086c1623"
    sha256 cellar: :any_skip_relocation, monterey:       "8a012aec875782a53923157a225853c0aa91890a89baf6b8798bd056ed472579"
    sha256 cellar: :any_skip_relocation, big_sur:        "17cd4e02de2ad61b2aa4e4e5dfdcfbea61bea0d6f56d0b54b99c8578f9e8912f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68bb258c4f9fe2a3612951aabbf8a92652f250066ccfce841cb7baec5a29e8c1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end