class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/87/b6/126c659ab7e0e03e01a5f5d223abf7b2c0691ae92718085a212a3924a2a3/fonttools-4.66.1.tar.gz"
  sha256 "64967c6ddb0d4c610dfd8cb1485981b2d27972ddfb7d4bbbd9e199d2a089c450"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2685cecbe142c10826f852c9f83c77716f34b449a37e0e53b65624b11e58fb6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db80d29847f5ae9b78c5617cc73280da6f03b8e1ce5deb48fe2985eb52976215"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2adae00af2f45ecd39be213beca8f3372849cd0d3d2c9a39318e53217abadfc"
    sha256 cellar: :any,                 arm64_linux:       "727b117b8a8e3eac4860ad873854dcc1e5bd374e4efba00dd0b36765fee268a8"
    sha256 cellar: :any,                 x86_64_linux:      "dbe79bfbfc6ab60cc90cd52a23a8ecefb461832f4a3a36dd4b8f363d655550c5"
  end

  depends_on "python@3.15"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages package_name: "fonttools[lxml,woff]"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
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