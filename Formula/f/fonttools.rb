class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/94/36/102e180f8f5dbaee88b26595b01ca8aa80bf4e62128d9aa94265b3996c96/fonttools-4.67.0.tar.gz"
  sha256 "3cb57e6600ca77c0b1729cf8adc23bc0652633a37f18cfa934d9c7bc3de25519"
  license "MIT"
  revision 1
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6919764460759dbede01bcc83a7212e6e2e225e259dd32c6f17508c5d68cd1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd46ad8a9a00d3bb64a9e9999456fe0810bfc0507f1f530f7d6f23397234d65a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c228f5fe9250571386fb3edda3b232e703383a10381d552eb163c7fa53a1530"
    sha256 cellar: :any,                 arm64_linux:       "eb5c27f5a351260c5c62a763049fdb33eac9f0015b3cdd0c6dd4fa99f4232842"
    sha256 cellar: :any,                 x86_64_linux:      "070d36a9fb9b52d758e220f9af712d70901198b97547e8ad614360b48a3f8df9"
  end

  depends_on "python@3.15"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages package_name: "fonttools[lxml,woff]"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/cf/81/1546c983678a9b4e77cb4718eaedd1b2caf24a6cdbf1eb8775938d22aff7/brotli-1.2.1.tar.gz"
    sha256 "02b2f7b5a83485efe448a44ddf7983def05c3bb1dcf917d4f7154070260e13de"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/74/21/3b6af43a663b22b00e738bb0642931a2579e15da6852613d56c6aa535d28/zopfli-0.4.3.tar.gz"
    sha256 "d3a50f91a13cea9bafe025de8fd87a005eb26de02a4f0c193127ddbf23ac8ebe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end