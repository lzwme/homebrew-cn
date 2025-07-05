class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/52/97/5735503e58d3816b0989955ef9b2df07e4c99b246469bd8b3823a14095da/fonttools-4.58.5.tar.gz"
  sha256 "b2a35b0a19f1837284b3a23dd64fd7761b8911d50911ecd2bdbaf5b2d1b5df9c"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69cbb0245f0d9227961c2971a5e2a42906e724717ab2ea8a84f4a2848b6093c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e5d173f2ba037189eb26369d53f293a77964c14a26a497bbe230ad5c2df6bd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2db306117265be80d8b5952e285f780b777133e69d17e047dbd81bab761156a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3f499a0e007c15061a58d0c523f2d0912889bfab57c662f8080c81d6d32990a"
    sha256 cellar: :any_skip_relocation, ventura:       "58c4f9393d51eac35414dbbd3e8930531fd8a8217943aed9b53c0d8c1c1c99e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fbaca03ee6951348e845c4f131227c425f43d703ab5c121518d7847d8fdfc6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab34cba81dfc20a027cdbb991ab31e91170b6fed48f7b511b6996158c0b4f638"
  end

  depends_on "python@3.13"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/5e/7c/a8f6696e694709e2abcbccd27d05ef761e9b6efae217e11d977471555b62/zopfli-0.2.3.post1.tar.gz"
    sha256 "96484dc0f48be1c5d7ae9f38ed1ce41e3675fd506b27c11a6607f14b49101e99"
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