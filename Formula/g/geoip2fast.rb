class Geoip2fast < Formula
  desc "GeoIP2 country/ASN lookup tool"
  homepage "https://github.com/rabuchaim/geoip2fast"
  url "https://files.pythonhosted.org/packages/96/c3/2abed46ccfec1f1c875d8f8e841e6bbaf33c471ccdfac12f559db70d17a2/geoip2fast-1.1.8.tar.gz"
  sha256 "e24f578ceae8dd6d56c7b625f7c82f66d70fd2300df1b30e10b4e3c797ccf9ae"
  license "MIT"
  head "https://github.com/rabuchaim/geoip2fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f999bb4afaa29f86f033fdbc6316b289e71a1c2b0158d0985fb4e7d63e4598d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36d87744e7fd44aaca31dc8538c6dbe0250068da43e344b6e7c6c23976cee444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2036fd43b13e7311d81b775b1185746b20cb409b9ffaaee3938374a9916bb037"
    sha256 cellar: :any_skip_relocation, sonoma:         "864e66a3cd21d3727e7ad611a22c3aae0188794c9cedc8802a66945ff4e381a8"
    sha256 cellar: :any_skip_relocation, ventura:        "7d1a34faf1dfc058f3a3545b43ec35cca56b78025e1f11d164de62cacbcfd58a"
    sha256 cellar: :any_skip_relocation, monterey:       "4af043208658bd0ce2391bf72d5e99cdba9a516d4fc7d521b4ff5a0c31666247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1321f2a461559db9a056caaee33e308e05e62134c4d9d1bdf2f2c4f0b7e0c92f"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output1 = shell_output("#{bin}/geoip2fast --self-test")
    assert_match "GeoIP2Fast v#{version} is ready! geoip2fast.dat.gz loaded", output1

    output2 = shell_output("#{bin}/geoip2fast 1.1.1.1")
    assert_match "\"country_name\": \"Australia\",", output2
  end
end