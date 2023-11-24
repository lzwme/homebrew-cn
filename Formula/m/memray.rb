class Memray < Formula
  include Language::Python::Virtualenv

  desc "Memory profiler for Python applications"
  homepage "https://bloomberg.github.io/memray/"
  url "https://files.pythonhosted.org/packages/d4/28/41748b83b7db03d9e3d25c19e48851af62505ba88100d1e25fc3b7d36027/memray-1.10.0.tar.gz"
  sha256 "38322e052b882790993412f1840517a51818aa55c47037f69915b2007f2c4cee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "859ea5b5f29ad0b5e4fdebc9112852a234ffd54767c3248255be6442ea929c9e"
    sha256 cellar: :any,                 arm64_ventura:  "142b345d5017fbf8bb69fd71f655df3304ef62844d3f2d74b09858c37f22be3b"
    sha256 cellar: :any,                 arm64_monterey: "1c3e9949b810d9bcf42aaba96146befc82fc4229650c624bce5f119aa4f61a87"
    sha256 cellar: :any,                 sonoma:         "82c66c67d45cd4182bdb6dd082b0a2b669023d5be6a484d9edb2465cd8a156e7"
    sha256 cellar: :any,                 ventura:        "21e4baea6cbaae4224ffa33343f8e0cb375bfa1ab240adbb52e379cc45c73d06"
    sha256 cellar: :any,                 monterey:       "f4deb8c4ef14eb1a75e1d3d6954c55eb50ffde0c1266fe414b2cbfc80ac5bb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32dbf00c1c73aa5fba8b6ed652acdd9925a6694b048dbd3ba9df94823fdd5fc2"
  end

  depends_on "lz4"
  depends_on "pygments"
  depends_on "python-jinja"
  depends_on "python-markupsafe"
  depends_on "python@3.12"

  on_linux do
    depends_on "libunwind"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/memray", "run", "--output", "output.bin", "-c", "print()"
    assert_predicate testpath/"output.bin", :exist?

    assert_match version.to_s, shell_output("#{bin}/memray --version")
  end
end