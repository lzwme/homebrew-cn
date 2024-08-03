class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https:www.gargoyle-router.comwikidoku.php?id=fon_flash"
  url "https:github.comericpaulbishopgargoylearchiverefstags1.14.0.tar.gz"
  sha256 "bd3ba67ab9cd8c7474ce8f02a3a320b91aec72c6710e43c18dbe719b13f3820a"
  license "GPL-2.0-or-later"
  head "https:github.comericpaulbishopgargoyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3578903bdf423bf0f5a01a50073bfe90c47aaf25b5a744156fa5d743c1db0086"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "086af945c76e6c4799d32edf90e501c888a39b70e38fc8624e2d4299f5d2cad6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab5a378106425caea9f5dfc715e23d920bb7f20b9b906e7206ce25ab1c003c2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2a970314d5ee43f5257e48c4889cceca44be1f635ebb6074ac62b328752f1d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4927ca94b069e1150ec07b27ced2d725eed9a7906b68eee85b342f97992b95fd"
    sha256 cellar: :any_skip_relocation, ventura:        "bea7e00d9364f56371c13a7f025d69322461ba39d2e9263c9b1a2ab0f78e8b00"
    sha256 cellar: :any_skip_relocation, monterey:       "614d3d86a8a73ed487ddd5991858a6c2719feda3b730d887e8842f14fbe0ddc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ba579da3c78c940d52fd2811b976cc2f1908a5fda863adf0b9e78447eec6e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f4ec92c15b63f45030ffff6df6400adf06eab3417e7c938c2eb1b84f2084cf"
  end

  uses_from_macos "libpcap"

  def install
    cd "fon-flash" do
      system "make", "fon-flash"
      bin.install "fon-flash"
    end
  end

  test do
    system bin"fon-flash"
  end
end