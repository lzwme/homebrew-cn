class Geoip2fast < Formula
  desc "GeoIP2 country/ASN lookup tool"
  homepage "https://github.com/rabuchaim/geoip2fast"
  url "https://files.pythonhosted.org/packages/27/48/b0477a7117b695dfe89eec0538abb0d66175cd7794060dcf5e3e57e2cfc6/geoip2fast-1.1.9.tar.gz"
  sha256 "3ece4b07d7df1924b91d989921f8f3a219297a47b42c1ca8d2a12b9742bbcbf0"
  license "MIT"
  head "https://github.com/rabuchaim/geoip2fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8f2d9ae48a1305f2b369ed1ea21a709d5ca5ea78e7c96e42d3d694a3b83189d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0a659e0504a9c13d86b3027dcd7e400350686d7c6685b96df81c0e79536d653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8aceaa615e2d15845b354f0940ce651772bf0a4bc8d160ccb685730420e2ef2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ba77e917eeb860df06145a9346463b7ee3936798103eb1120deb2d2daa4a04e"
    sha256 cellar: :any_skip_relocation, ventura:        "20cfd30239b53d9f02d88160b26d093716f2544a971d0759be272861f480ae5f"
    sha256 cellar: :any_skip_relocation, monterey:       "54e9cfed3fc76d85ace156e9487949d2e16d7aedc510195d13512e80af48e96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0537f8cab5344f9e217a694673972b4ae2c59049fef97fd90c5c360f6091f54f"
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