class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/30/d9/44e654344d0078bdf8c734adee3274a534865a4e444c3cb9b826ef8cc57b/fonttools-4.45.1.tar.gz"
  sha256 "6e441286d55fe7ec7c4fb36812bf914924813776ff514b744b510680fc2733f2"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c584be37ec553eec21aa746b53332a72116627d54d59b7999d247a1253262e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e4def0cfb2c0de2fc522a6953cd76a6107d405b364977dd70f754fe0a2a7c84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8ea78e5b2319dcc6214da6c2640ee7df09b81819fd7bc9bc2c9a565e12c73c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8b512349b0b793b1ae663d44b341612100e599c41112e79789c6b7f17a2faef"
    sha256 cellar: :any_skip_relocation, ventura:        "ee07e8ff42751a89b5f3af0a933d2de4d0d010e6fdea1a112e8a037552a6ad29"
    sha256 cellar: :any_skip_relocation, monterey:       "e39d9b18b405fa1b3f00882dfba1a134d388b27720fa49476ee8615ceb50a81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a9d7f549cd38b0833a72a7458146a711f64d0cce172adfe29a0836ac6da8a23"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-brotli"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.ttx", :exist?
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_predicate testpath/"ZapfDingbats.woff2", :exist?
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end