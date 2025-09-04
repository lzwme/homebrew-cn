class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/b0/62/567d25ae4fbd65db92428f78c414e34ad3d50b79af98b7944a774eeae0d0/translate_toolkit-3.16.0.tar.gz"
  sha256 "25873a142a5c98f7a114fc725e7c50e7f63df38ebc11db21437c527cf724880a"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "971756c07f169b7ead66441643bf808f0ac8ce55771f8e7a4fde14c466786200"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77428f729de2c201739d50d5bc8936c900527ebf614e47b49f47e191e4a382ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3eca05dd3e03ef7f128b695c268eaa72712b222e22fc8fb1cf59620ee5c493b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb578e488a17ed4a32ee4045eeafc6864ee2cc216ededf7375cc9a45005d22e5"
    sha256 cellar: :any_skip_relocation, ventura:       "abc518bde0a25c05b8fe351aa351a0d9cffb4791204ea374038bc4920977e944"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05ea8cbf4c97b48cd4da4f7f914e34ddb4cd4bf478863a0bb08ecbfb2d657a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "612d356fd98295cd464aa08de3eeab15dbdf1d12e28a8e49e3fd70cac221ea93"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/23/76/03fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152/cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end