class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https:arrow.apache.orgdatafusion"
  url "https:github.comapachearrow-datafusionarchiverefstags40.0.0.tar.gz"
  sha256 "ece01894bc4cc6912785e417f8576ab4a62babd8e4676a6bd3aa5d165c18d0e2"
  license "Apache-2.0"
  head "https:github.comapachearrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d533d83c9a1568e784335ce07af65d4370f48008b970322866615829bdc10b8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "350f59e02e6ddc16d5ea34b6b2385c2955eb0abe2dceb4d2445e79e30b0b862b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b5dc239bf112442423568a0fe03ddd0db609034fc66cef6a62feb909350d791"
    sha256 cellar: :any_skip_relocation, sonoma:         "8079d0fab2d11b0a5fa41375f2f54e9e87eabb4609e3dd1dc5a10e5161b71dba"
    sha256 cellar: :any_skip_relocation, ventura:        "bf561268cede7c44d5cee2793cb5622ab1a4f3cd7e62a8d6546f94246ed9b7a0"
    sha256 cellar: :any_skip_relocation, monterey:       "efb1e456bb9e28307796f9c13d27b56fb3023830ac9622ef40edb75c99276fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a50f29d0d9e08619f449eeb735cc9afea4d8544faea49b206e9011ec198f76df"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end