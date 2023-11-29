class Arjun < Formula
  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/83/2d/e521035e38c81c9d7f4aa02a287dddeb163ad51ebca28bef7563fc503c07/arjun-2.2.2.tar.gz"
  sha256 "3b2235144e91466b14474ab0cad1bcff6fb1313edb943a690c64ed0ff995cc46"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b383c810957b9abbfb679cf4f2bb2b7c11fd8cd4a732751baf50a3ae5a56232c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fabe5baf56119662c1a948b0f496da10a2c0121009c4e3fe28b8ec66a578c5df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50299a67611d931ea4db42181dcd7ed3aac5888c63c96156bebe3f7cfb6dbb0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4b6e981329cd53af271bea8bd26ba5049b3a420ed9a6040af162af325f8c149"
    sha256 cellar: :any_skip_relocation, ventura:        "1778f8981e95ee71306599cc609595a1d9f25b9965a8213794ffe3ea25d51ddb"
    sha256 cellar: :any_skip_relocation, monterey:       "f7f28d677a0a46c89b2c9a2a1768bae436fe484945021ca7249924138adb4b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c2d40b7150decd2cbb95201c8eff966fc477d3ce3612275c7e60984882486d"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-dicttoxml"
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET")
    assert_match "No parameters were discovered", output
  end
end