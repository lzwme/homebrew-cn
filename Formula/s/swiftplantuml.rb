class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https:github.comMarcoEidingerSwiftPlantUML"
  url "https:github.comMarcoEidingerSwiftPlantUMLarchiverefstags0.7.7.tar.gz"
  sha256 "da632fe8d97326ac914ddbb676328faae4e26eab6f506f8a138ea20636528403"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c7e99a66454ab93d25b12a033f8a3ad0523f705becaef9e98983000f1d8aeea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20ef718b80c7a0b84085f2ec44af10e1bcc8d4071f98290001adbc2d6b0b66bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b6c8e78dd39373e254f2a599d79c10b9895a306a47202be4055c6d14e14075"
    sha256 cellar: :any_skip_relocation, sonoma:         "686c65d524ea253f079423347e52b211c1b3322d929032c81d19d7f13c2e246f"
    sha256 cellar: :any_skip_relocation, ventura:        "04dee9a6954b046105871d1fd63a61aad9a39cbb02e76aa312131088da42106a"
    sha256 cellar: :any_skip_relocation, monterey:       "bad92434830d4eaefd4fad89c271450e9d21dd4041fcf69c8732c3729b7df421"
  end

  depends_on xcode: ["12.2", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}swiftplantuml", "--help"
  end
end