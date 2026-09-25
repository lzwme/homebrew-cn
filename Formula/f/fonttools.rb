class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/a2/24/86f9930b930b97fc82266083320f3c34643ef67261c32651e893db525aca/fonttools-4.66.0.tar.gz"
  sha256 "ef0610dfe7bb5bf574d9bdad6f597403ebc9807d124ac6f148d7604b2609be98"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98028fba9458995aab714fa6f116bcd8b7110fee2f383b01fd22d7dfcd758fff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "979ec42a918f879e75eb1b54017e011ffa341373a19dd51a6cdf73a6820da71a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba870a5443ecc049cc3b21fec029afd0f89505f488e066f10976a4d6489dd0a0"
    sha256 cellar: :any,                 arm64_linux:       "145a4d324fd475c0576b37ae34c09c6dad97c6b7f9425c4b5959e914ffcf99d1"
    sha256 cellar: :any,                 x86_64_linux:      "089dfe3825a8fea24ac0e09e584eac59ed99eb3994057f5aa53e68f98d8d1e38"
  end

  depends_on "python@3.14"

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