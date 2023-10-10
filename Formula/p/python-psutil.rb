class PythonPsutil < Formula
  desc "Cross-platform lib for process and system monitoring in Python"
  homepage "https://github.com/giampaolo/psutil"
  url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
  sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfc753ad814ed6668a9032dd73d593a86c2de9999ceecf792d64fae364368eca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0e3599445f848c04325c850618d43856f21cda1aee45a6768bd4016a8cf1ff0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e268a7903806cc560d9b0e28cfa0550743d9807791447ddb67e943813d19a242"
    sha256 cellar: :any_skip_relocation, sonoma:         "fea26b01f6b0d4ae5f7bae5513555ef7e1b7519df21f6bde0261ebc1b1aadff3"
    sha256 cellar: :any_skip_relocation, ventura:        "15a0758c19cd1722ed26cd0229ca00d29b8b564406244936a6f92c984e67b7d5"
    sha256 cellar: :any_skip_relocation, monterey:       "ed49723871f4e75781203c1220ea400626bcf2a57a3d7bebd4049c039f94ef20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de672d146c7a5744833c6facf2dfbefe4cd5173f464364c99d63184204f90afd"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system python3, "-c", "import psutil"
  end
end